import '../styles/application.scss';
import '../src/govukFrontendAssets';
import { initAll } from 'govuk-frontend/govuk/all';
import printLink from '../src/printLink/init';
import cookieControl from '../src/cookieControl';
import backLink from '../src/backLink';
import '@fortawesome/fontawesome-free/css/regular.min.css';

require('@rails/ujs').start();

document.body.classList.add('js-enabled');
initAll();
printLink();
cookieControl();
backLink();
