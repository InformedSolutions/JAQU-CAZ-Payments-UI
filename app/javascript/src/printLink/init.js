function init() {
  const printLink = document.getElementById('print-page-link');
  if (printLink)
  {
    printLink.classList.remove('govuk-visually-hidden');
    printLink.addEventListener('click', (event) => {
        event.preventDefault();
        window.print();
    }, false);
  }
}

export default init;
