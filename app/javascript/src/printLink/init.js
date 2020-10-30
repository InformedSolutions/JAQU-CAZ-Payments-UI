import './styles.scss'

function init() {
  const printLink = document.getElementById('print-page-link');
  if (printLink)
  {
    printLink.classList.remove('print-page-link__hidden');
    printLink.addEventListener('click', (event) => {
      event.preventDefault();
      window.print();
    }, false);
  }
}

export default init;
