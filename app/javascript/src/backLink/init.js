function init() {
  const backLink = document.getElementById('js-back-link');
  if (backLink) {
    backLink.style.display = 'inline-block';
    backLink.addEventListener('click', (event) => {
      event.preventDefault();
      history.back();
    }, false);
  }
}
  
export default init;
