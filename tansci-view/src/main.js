import { createApp } from 'vue';
import App from './App.vue';
import router from './router'; // Assuming you have a router file
import store from './store';   // Assuming you have a store file
import ElementPlus from 'element-plus';
import 'element-plus/dist/index.css';

// ------------------------------------------------------------------
// 核心修复区域：Element Plus 语言包导入路径修正
// 旧的路径 (e.g., 'element-plus/lib/locale/lang/zh-cn') 导致构建失败
// 新版本应使用 'element-plus/dist/locale/zh-cn.mjs' 或 'element-plus/es/locale/lang/zh-cn'
// ------------------------------------------------------------------
import zhCn from 'element-plus/es/locale/lang/zh-cn'; // 推荐使用 ES Module 路径
// import zhCn from 'element-plus/dist/locale/zh-cn.mjs'; // 另一种稳定路径

const app = createApp(App);

// 挂载路由和状态管理
app.use(router);
app.use(store);

// 挂载 Element Plus 并设置中文语言包
app.use(ElementPlus, {
  locale: zhCn, // 使用修正后的中文语言包
});

app.mount('#app');
