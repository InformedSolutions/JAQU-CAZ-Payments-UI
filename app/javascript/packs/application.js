require("@rails/ujs").start();

import '../styles/application.scss';
import '../src/govukFrontendAssets';
import { initAll } from 'govuk-frontend/govuk/all.js';
import initPrintLink from '../src/printLink/init';
import cookieControl from "../src/cookieControl";
import initBackLink from '../src/backLink/init';
import '@fortawesome/fontawesome-free/css/regular.min.css';

document.body.classList.add('js-enabled');
initAll();
initPrintLink();
cookieControl();
initBackLink();
