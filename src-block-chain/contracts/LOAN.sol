
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.0;

contract Loan {

    struct Arbitral {
        string ArbitralName;
        address ArbitralInstitutionAddress;
    }

    struct Bank {
        string bankName;

        uint[] ReceiptIndex_loanMoneyToCompany;

        uint[] ReceiptIndex_authorizeCreditAssetToCompany;

        uint[] ReceiptIndex_getRepaidMoneyFromTrustedCompany;

        mapping (string => uint) companyDebtAmount;

        address bankAddr;
    }

    struct Company {
        string companyName;
        string companyType;

        bool isTrusted;

        uint creditAsset;
        uint[] ReceiptIndex_getCreditAssetFromCompanyOrBank;
        uint[] ReceiptIndex_giveCreditAssetToCompany;

        uint realMoney;
        uint[] ReceiptIndex_getRealMoneyFromBank;
        uint[] ReceiptIndex_repayRealMoneyToBank;

        address companyAddr;
    }

    struct Receipt_A_gives_things_to_B {
        string Name_A;
        string Name_B;
        bool bankParticipation;
        bool isRealMoney;
        uint amount;

        bool A_sign;
        bool B_sign;
    }
    
    Arbitral public arbitralInstitution;
    
    Company[] public companies;
    uint numCompanies;
    Bank[] public banks;
    uint numBanks;
    Receipt_A_gives_things_to_B[] public receipts;

    mapping (string => uint) doubleSig;
    
    bool public trustedCompanyHasFinishedWithBank = false;
    
    
    constructor(string memory arbitralInstitutionName){
        arbitralInstitution = Arbitral({
            ArbitralName: arbitralInstitutionName,
            ArbitralInstitutionAddress: msg.sender
        });
    }
    
    
    function addCompany(string memory cpName, string memory cpType, bool whetherTrusted, address cAddr) public returns (bool)  {
        require(msg.sender == arbitralInstitution.ArbitralInstitutionAddress, "Only arbitral institution can add a company.");
        require(keccak256(bytes(cpType)) != keccak256(bytes("bank")), "Please use addBank method to add a bank.") ;
        for(uint i = 0; i < companies.length; i++) {
            require(keccak256(bytes(cpName)) != keccak256(bytes(companies[i].companyName)), "This company name already exsits.");
        }
        for(uint j = 0; j < banks.length; j++) {
            require(keccak256(bytes(cpName)) != keccak256(bytes(banks[j].bankName)), "Cannot add the company because a bank of the same name exsits.");
        }
        
        companies.push(Company({
            companyName: cpName, 
            companyType: cpType, 
            isTrusted: whetherTrusted,
            creditAsset: 0,
            ReceiptIndex_getCreditAssetFromCompanyOrBank: new uint[](0),
            
            ReceiptIndex_giveCreditAssetToCompany: new uint[](0),
            
            realMoney: 0,
            ReceiptIndex_getRealMoneyFromBank: new uint[](0),
            ReceiptIndex_repayRealMoneyToBank: new uint[](0),

            companyAddr: cAddr
        }));
        
        
        /*
        Company storage c = new Company;
        c.companyName = cpName;
        c.companyType = cpType;
        c.isTrusted = whetherTrusted;
        c.creditAsset = 0;
        c.ReceiptIndex_getCreditAssetFromCompanyOrBank = new uint[](0);
        c.ReceiptIndex_giveCreditAssetToCompany = new uint[](0);
        c.realMoney = 0;
        c.ReceiptIndex_getRealMoneyFromBank = new uint[](0);
        c.ReceiptIndex_repayRealMoneyToBank = new uint[](0);
        companies.push(c);
        */

        return true;
    }
    
    
    function addBank(string memory bName, address bAddr) public returns(bool) {
        require(msg.sender == arbitralInstitution.ArbitralInstitutionAddress, "Only arbitral institution can add a bank.");
        for(uint i = 0; i < banks.length; i++) {
            require(keccak256(bytes(bName)) != keccak256(bytes(banks[i].bankName)), "This bank name already exsits.");
        }
        for(uint j = 0; j < companies.length; j++) {
            require(keccak256(bytes(bName)) != keccak256(bytes(companies[j].companyName)), "Cannot add the bank because a company of the same name exsits.");
        }
        /*
        banks.push(Bank({
            bankName: bName, 
            ReceiptIndex_loanMoneyToCompany: new uint[](0),
            ReceiptIndex_authorizeCreditAssetToCompany: new uint[](0),
            ReceiptIndex_getRepaidMoneyFromTrustedCompany: new uint[](0)
        }));
        */

        /*
        Bank storage b = new Bank;
        b.bankName = bName;
        b.ReceiptIndex_loanMoneyToCompany = new uint[](0);
        b.ReceiptIndex_authorizeCreditAssetToCompany = new uint[](0);
        b.ReceiptIndex_getRepaidMoneyFromTrustedCompany = new uint[](0);
        banks.push(b);
        */

        banks.push();
        Bank storage b = banks[numBanks];
        numBanks ++;
        b.bankName = bName;
        b.ReceiptIndex_loanMoneyToCompany = new uint[](0);
        b.ReceiptIndex_authorizeCreditAssetToCompany = new uint[](0);
        b.ReceiptIndex_getRepaidMoneyFromTrustedCompany = new uint[](0);
        b.bankAddr = bAddr;

        return true;
    }
    
    function newReceipt(string memory nameA, string memory nameB, uint amt, bool bankParticipates, bool realMoney, uint Exist) internal returns(uint) {
        if(Exist == 1){
            receipts.push(Receipt_A_gives_things_to_B({
                Name_A: nameA, 
                Name_B: nameB, 
                amount: amt, 
                bankParticipation: bankParticipates,
                isRealMoney: realMoney,
                A_sign: true,
                B_sign: false
            }));
        }
        if(Exist == 2){
            receipts.push(Receipt_A_gives_things_to_B({
                Name_A: nameA, 
                Name_B: nameB, 
                amount: amt, 
                bankParticipation: bankParticipates,
                isRealMoney: realMoney,
                A_sign: false,
                B_sign: true
            }));
        }
        return receipts.length;
    }

    // add index; return index
    function bank_giveCreditAssetTo_trustedCompany(uint index, string memory bName, string memory cpName, uint amt) public returns(uint) {
        if(index > 0){
            uint num = index - 1;
            if(keccak256(bytes(receipts[num].Name_A)) == keccak256(bytes(bName)) || keccak256(bytes(receipts[num].Name_B)) == keccak256(bytes(cpName)) || receipts[num].amount == amt){
                
                if(receipts[num].A_sign == false){
                    for(uint idx = 0; idx < banks.length; idx++) {
                        if(msg.sender == banks[idx].bankAddr && keccak256(bytes(bName)) == keccak256(bytes(banks[idx].bankName))){
                            receipts[num].A_sign = true;
                            return index;
                        }
                    }
                }
                if(receipts[num].B_sign == false){
                    for(uint idx = 0; idx < companies.length; idx++) {
                        if(msg.sender == companies[idx].companyAddr && keccak256(bytes(cpName)) == keccak256(bytes(companies[idx].companyName))){
                            receipts[num].B_sign = true;
                            return index;
                        }
                    }
                }
            }
        }
        if(index == 0){
            require(amt > 0, "Amount must be positive!");
            bool bName_Valid = false;
            bool cpName_Valid = false;
            uint b_Index = 0;
            uint cp_Index = 0;
            for(uint idx = 0; idx < banks.length; idx++) {
                if(keccak256(bytes(bName)) == keccak256(bytes(banks[idx].bankName))){
                    bName_Valid = true;
                    b_Index = idx;
                    break;
                }
            }
            for(uint idx = 0; idx < companies.length; idx++) {
                if(keccak256(bytes(cpName)) == keccak256(bytes(companies[idx].companyName))){
                    cpName_Valid = true;
                    cp_Index = idx;
                    break;
                }
            }

            uint Exist = 0;
            if(msg.sender == banks[b_Index].bankAddr){
                Exist = 1;
            }
            else if(msg.sender == companies[cp_Index].companyAddr){
                Exist = 2;
            }
            else{
                revert("unauthorized.");
            }

            require(bName_Valid == true, "Bank name is invalid!");
            require(cpName_Valid == true, "Company name is invalid!");

            require(companies[cp_Index].isTrusted == true, "Company is not trusted!");

            uint currentReceiptIndex = newReceipt(bName, cpName, amt, true, false, Exist);

            banks[b_Index].ReceiptIndex_authorizeCreditAssetToCompany.push(currentReceiptIndex);
            banks[b_Index].companyDebtAmount[cpName] += amt;

            companies[cp_Index].creditAsset += amt;
            companies[cp_Index].ReceiptIndex_getCreditAssetFromCompanyOrBank.push(currentReceiptIndex);

            return currentReceiptIndex;
        }
    }

    
    function companyA_giveCreditAssetTo_companyB(uint index, string memory companyName_A, string memory companyName_B, uint amt) public  returns(uint) {
        require(keccak256(bytes(companyName_A)) != keccak256(bytes(companyName_B)), "Company A and Company B should be different!");
        require(amt > 0, "Amount must be positive!");
        if(index > 0){
            uint num = index - 1;
            if(keccak256(bytes(receipts[num].Name_A)) == keccak256(bytes(companyName_A)) || keccak256(bytes(receipts[num].Name_B)) == keccak256(bytes(companyName_B)) || receipts[num].amount == amt){

                if(receipts[num].A_sign == false){
                    for(uint idx = 0; idx < companies.length; idx++) {
                        if(msg.sender == companies[idx].companyAddr && keccak256(bytes(companyName_A)) == keccak256(bytes(companies[idx].companyName))){
                            receipts[num].A_sign = true;
                            return index;
                        }
                    }
                }
                if(receipts[num].B_sign == false){
                    for(uint idx = 0; idx < companies.length; idx++) {
                        if(msg.sender == companies[idx].companyAddr && keccak256(bytes(companyName_B)) == keccak256(bytes(companies[idx].companyName))){
                            receipts[num].B_sign = true;
                            return index;
                        }
                    }
                }
            }
        }
        if(index == 0){
            bool Name_A_Valid = false;
            bool Name_B_Valid = false;
            uint companyA_Index = 0;
            uint companyB_Index = 0;
            for(uint i = 0; i < companies.length; i++) {
                if(keccak256(bytes(companyName_A)) == keccak256(bytes(companies[i].companyName))) {
                    Name_A_Valid = true;
                    companyA_Index = i;
                }
                if(keccak256(bytes(companyName_B)) == keccak256(bytes(companies[i].companyName))) {
                    Name_B_Valid = true;
                    companyB_Index = i;
                }
            }
            require(Name_A_Valid == true, "Company A name is invalid!");
            require(Name_B_Valid == true, "Company B name is invalid!");
            require(companies[companyA_Index].creditAsset >= amt, "Company A's creditAsset should be more than the loan amount!");

            uint Exist = 0;
            if(msg.sender == companies[companyA_Index].companyAddr){
                Exist = 1;
            }
            else if(msg.sender == companies[companyB_Index].companyAddr){
                Exist = 2;
            }
            else{
                revert("unauthorized.");
            }

            uint currentReceiptIndex = newReceipt(companyName_A, companyName_B, amt, false, false, Exist);

            companies[companyA_Index].creditAsset -= amt;
            companies[companyA_Index].ReceiptIndex_giveCreditAssetToCompany.push(currentReceiptIndex);

            companies[companyB_Index].creditAsset += amt;
            companies[companyB_Index].ReceiptIndex_getCreditAssetFromCompanyOrBank.push(currentReceiptIndex);

            return currentReceiptIndex;
        }
    }


    function bank_giveRealMoneyTo_company(uint index, string memory bName, string memory cpName, uint amt) public returns(uint) {
        require(amt > 0, "Amount must be positive!");

        if(index > 0){
            uint num = index - 1;
            if(keccak256(bytes(receipts[num].Name_A)) == keccak256(bytes(bName)) || keccak256(bytes(receipts[num].Name_B)) == keccak256(bytes(cpName)) || receipts[num].amount == amt){
                
                if(receipts[num].A_sign == false){
                    for(uint idx = 0; idx < banks.length; idx++) {
                        if(msg.sender == banks[idx].bankAddr && keccak256(bytes(bName)) == keccak256(bytes(banks[idx].bankName))){
                            receipts[num].A_sign = true;
                            return index;
                        }
                    }
                }
                if(receipts[num].B_sign == false){
                    for(uint idx = 0; idx < companies.length; idx++) {
                        if(msg.sender == companies[idx].companyAddr && keccak256(bytes(cpName)) == keccak256(bytes(companies[idx].companyName))){
                            receipts[num].B_sign = true;
                            return index;
                        }
                    }
                }
            }
        }

        if(index == 0){
            bool bName_Valid = false;
            bool cpName_Valid = false;
            uint b_Index = 0;
            uint cp_Index = 0;
            for(uint j = 0; j < banks.length; j++) {
                if(keccak256(bytes(bName)) == keccak256(bytes(banks[j].bankName))) {
                    bName_Valid = true;
                    b_Index = j;
                }
            }
            for(uint i = 0; i < companies.length; i++) {
                if(keccak256(bytes(cpName)) == keccak256(bytes(companies[i].companyName))) {
                    cpName_Valid = true;
                    cp_Index = i;
                }
            }
            require(bName_Valid == true, "Bank name is invalid!");
            require(cpName_Valid == true, "Company name is invalid!");

            require(companies[cp_Index].creditAsset >= amt, "Company's credit assest is not enough!");

            uint Exist = 0;
            if(msg.sender == companies[b_Index].companyAddr){
                Exist = 1;
            }
            else if(msg.sender == companies[cp_Index].companyAddr){
                Exist = 2;
            }
            else{
                revert("unauthorized.");
            }

            uint currentReceiptIndex = newReceipt(bName, cpName, amt, true, true, Exist);

            banks[b_Index].ReceiptIndex_authorizeCreditAssetToCompany.push(currentReceiptIndex);

            companies[cp_Index].creditAsset -= amt;
            companies[cp_Index].realMoney += amt;
            companies[cp_Index].ReceiptIndex_getRealMoneyFromBank.push(currentReceiptIndex);

            return currentReceiptIndex;
        }
    }


    function trustedCompany_repaidTo_bank(uint index, string memory cpName, string memory bName, uint amt) public returns(uint) {
        require(amt > 0, "Amount must be positive!");

        if(index > 0){
            uint num = index - 1;
            if(keccak256(bytes(receipts[num].Name_A)) == keccak256(bytes(cpName)) || keccak256(bytes(receipts[num].Name_B)) == keccak256(bytes(bName)) || receipts[num].amount == amt){
                
                if(receipts[num].B_sign == false){
                    for(uint idx = 0; idx < banks.length; idx++) {
                        if(msg.sender == banks[idx].bankAddr && keccak256(bytes(bName)) == keccak256(bytes(banks[idx].bankName))){
                            receipts[num].A_sign = true;
                            return index;
                        }
                    }
                }
                if(receipts[num].A_sign == false){
                    for(uint idx = 0; idx < companies.length; idx++) {
                        if(msg.sender == companies[idx].companyAddr && keccak256(bytes(cpName)) == keccak256(bytes(companies[idx].companyName))){
                            receipts[num].B_sign = true;
                            return index;
                        }
                    }
                }
            }
        }

        if(index == 0){
            bool bName_Valid = false;
            bool cpName_Valid = false;
            uint b_Index = 0;
            uint cp_Index = 0;
            for(uint j = 0; j < banks.length; j++) {
                if(keccak256(bytes(bName)) == keccak256(bytes(banks[j].bankName))) {
                    bName_Valid = true;
                    b_Index = j;
                }
            }
            for(uint i = 0; i < companies.length; i++) {
                if(keccak256(bytes(cpName)) == keccak256(bytes(companies[i].companyName))) {
                    cpName_Valid = true;
                    cp_Index = i;
                }
            }
            require(bName_Valid == true, "Bank name is invalid!");
            require(cpName_Valid == true, "Company name is invalid!");

            require(companies[cp_Index].isTrusted == true, "Only trusted company can repay to bank!");
            require(amt <= (banks[b_Index].companyDebtAmount[cpName] - companies[cp_Index].creditAsset), "Repay amount is more than the needed!");

            uint Exist = 0;
            if(msg.sender == companies[cp_Index].companyAddr){
                Exist = 1;
            }
            else if(msg.sender == banks[b_Index].bankAddr){
                Exist = 2;
            }
            else{
                revert("unauthorized.");
            }

            uint currentReceiptIndex = newReceipt(cpName, bName, amt, true, true, Exist);

            banks[b_Index].ReceiptIndex_getRepaidMoneyFromTrustedCompany.push(currentReceiptIndex);
            banks[b_Index].companyDebtAmount[cpName] -= amt;

            companies[cp_Index].ReceiptIndex_repayRealMoneyToBank.push(currentReceiptIndex);

            return currentReceiptIndex;
        }

    }



    function trustedCompany_FinishWith_Bank(string memory cpName, string memory bName) public returns(bool) {
        bool bName_Valid = false;
        bool cpName_Valid = false;
        uint b_Index = 0;
        uint cp_Index = 0;
        for(uint j = 0; j < banks.length; j++) {
            if(keccak256(bytes(bName)) == keccak256(bytes(banks[j].bankName))) {
                bName_Valid = true;
                b_Index = j;
            }
        }
        for(uint i = 0; i < companies.length; i++) {
            if(keccak256(bytes(cpName)) == keccak256(bytes(companies[i].companyName))) {
                cpName_Valid = true;
                cp_Index = i;
            }
        }
        require(msg.sender == companies[cp_Index].companyAddr, "Company: unauthorized.");
        require(bName_Valid == true, "Bank name is invalid!");
        require(cpName_Valid == true, "Company name is invalid!");

        require(companies[cp_Index].isTrusted == true, "Only trusted company can finish business with bank!");

        require(companies[cp_Index].creditAsset == banks[b_Index].companyDebtAmount[cpName], "The trusted company still has unrepaid money!");

        companies[cp_Index].creditAsset = 0;
        banks[b_Index].companyDebtAmount[cpName] = 0;
        trustedCompanyHasFinishedWithBank = true;

        return true;
    }

    

    function getCompanyInfoByName(string memory cpName) public view returns(string memory, string memory, bool, uint, uint) {
        bool Name_A_Valid = false;
        uint companyA_Index = 0;
        for(uint i = 0; i < companies.length; i++) {
            if(keccak256(bytes(cpName)) == keccak256(bytes(companies[i].companyName))) {
                Name_A_Valid = true;
                companyA_Index = i;
            }
        }
        require(Name_A_Valid == true, "Company A name is invalid!");
        return (companies[companyA_Index].companyName, 
                companies[companyA_Index].companyType, 
                companies[companyA_Index].isTrusted, 
                companies[companyA_Index].creditAsset, 
                companies[companyA_Index].realMoney);
    }


    function getBankInfoByName(string memory bName) public view returns(string memory) {
        bool bName_Valid = false;
        uint b_Index = 0;
        for(uint j = 0; j < banks.length; j++) {
            if(keccak256(bytes(bName)) == keccak256(bytes(banks[j].bankName))) {
                bName_Valid = true;
                b_Index = j;
            }
        }
        require(bName_Valid == true, "Bank name is invalid!");
        return banks[b_Index].bankName;
    }

    /*
    struct Receipt_A_gives_things_to_B {
        string Name_A;
        string Name_B;
        bool bankParticipation;
        bool isRealMoney;
        uint amount;

        bool A_sign;
        bool B_sign;
    }
    */
    
    function getReceiptInfoByIndex(uint index) public view returns(string memory, string memory, bool, bool, uint, bool, bool){
        require(index <= receipts.length, "Index is too big!");
        require(index > 0, "Index less than 0!");
        uint num = index - 1;
        return (receipts[num].Name_A, 
                receipts[num].Name_B, 
                receipts[num].bankParticipation, 
                receipts[num].isRealMoney, 
                receipts[num].amount,
                receipts[num].A_sign, 
                receipts[num].B_sign
                );
    }
    
    
    function getAmountOfCreditAsset_bankGiveToTrustedCompany(string memory bName, string memory cpName) public view returns(uint) {
        bool bName_Valid = false;
        bool cpName_Valid = false;
        uint b_Index = 0;
        uint cp_Index = 0;
        for(uint j = 0; j < banks.length; j++) {
            if(keccak256(bytes(bName)) == keccak256(bytes(banks[j].bankName))) {
                bName_Valid = true;
                b_Index = j;
            }
        }
        for(uint i = 0; i < companies.length; i++) {
            if(keccak256(bytes(cpName)) == keccak256(bytes(companies[i].companyName))) {
                cpName_Valid = true;
                cp_Index = i;
            }
        }
        require(bName_Valid == true, "Bank name is invalid!");
        require(cpName_Valid == true, "Company name is invalid!");

        require(companies[cp_Index].isTrusted == true, "Company is not trusted!");

        return banks[b_Index].companyDebtAmount[cpName];
    }


    function getCompanyNum() public view returns(uint) {
        return companies.length;
    }


    function getBankNum() public view returns (uint) {
        return banks.length;
    }


    function getReceiptNum() public view returns (uint) {
        return receipts.length;
    }


}