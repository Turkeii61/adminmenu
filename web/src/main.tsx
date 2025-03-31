import ReactDOM from 'react-dom/client';
import { isEnvBrowser } from '@/lib/constants';
import '@/styles/index.scss';
import '../public/fonts.css'
import App from './app';
if (isEnvBrowser) document.body.style.backgroundColor = 'black';

ReactDOM.createRoot(document.body!).render(<><App /></>);