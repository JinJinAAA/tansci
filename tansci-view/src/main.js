import { createApp } from 'vue';
import App from './App.vue';
import router from './router'; 
import store from './store';   
import ElementPlus from 'element-plus';
import 'element-plus/dist/index.css';

// ------------------------------------------------------------------
// 核心修复区域：Element Plus 语言包导入路径修正
// 切换到 ES 模块路径 'element-plus/es/locale/lang/zh-cn' 
// ------------------------------------------------------------------
import zhCn from 'element-plus/es/locale/lang/zh-cn';

const app = createApp(App);

// 挂载路由和状态管理
app.use(router);
app.use(store);

// 挂载 Element Plus 并设置中文语言包
app.use(ElementPlus, {
  locale: zhCn, 
});

app.mount('#app');
