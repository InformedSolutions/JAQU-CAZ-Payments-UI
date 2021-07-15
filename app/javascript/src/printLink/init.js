import './styles.scss';

export default function printLink() {
  const link = document.getElementById('print-page-link');
  if (link) {
    link.classList.remove('print-page-link__hidden');
    link.addEventListener('click', (event) => {
      event.preventDefault();
      window.print();
    }, false);
  }
}
