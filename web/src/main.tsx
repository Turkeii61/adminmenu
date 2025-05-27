import ReactDOM from 'react-dom/client';
import { isEnvBrowser } from 'react-router-dom';
import '@/styles/index.css';
import '../public/fonts.css';
import { App } from './App';
if (isEnvBrowser) document.documentElement.classList.add('black');

ReactDOM.createRoot(document.body!).render(<App />/>);