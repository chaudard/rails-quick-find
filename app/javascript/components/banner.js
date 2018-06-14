import Typed from 'typed.js';

function loadDynamicBannerText() {
  new Typed('#banner-typed-text', {
    strings: ["Get the right cloth...","...at the right place !"],
    typeSpeed: 100,
    loop: true
  });
}

export { loadDynamicBannerText };
