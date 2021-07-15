export default function cookieControl() {
  const onPageStyle = '#ccc-button-holder{display:none;}';
  const style = document.createElement('style');
  style.innerHTML = onPageStyle;
  document.head.appendChild(style);
}
