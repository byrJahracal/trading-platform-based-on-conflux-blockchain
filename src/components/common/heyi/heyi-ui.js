import HyHeader from "./header/header"
import HyCard from './card/card'

const components = [
  HyCard,
  HyHeader
]

const install = function (Vue) {
  if (install.installed) return
  components.map(component => Vue.component(component.name, component))
}


if (typeof window !== 'undefined' && window.Vue) {
  install(window.Vue)
}

export default {
  install,
  HyHeader,
  HyCard
}