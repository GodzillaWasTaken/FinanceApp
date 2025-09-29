import { createApp } from 'vue'
import { createPinia } from 'pinia'
import App from './App.vue'
import router from './router'
import './assets/index.css'

import ECharts from 'vue-echarts'
import { use } from 'echarts/core'
import { CanvasRenderer } from 'echarts/renderers'
import { BarChart, LineChart, PieChart } from 'echarts/charts'
import { TitleComponent, TooltipComponent, LegendComponent, GridComponent } from 'echarts/components'
use([ CanvasRenderer, 
    BarChart, 
    LineChart, 
    PieChart, 
    TitleComponent, 
    TooltipComponent, 
    LegendComponent, 
    GridComponent 
])

const app = createApp(App)
const pinia = createPinia()

app.use(pinia)
app.use(router)
app.component('v-chart', ECharts)

app.mount('#app')

