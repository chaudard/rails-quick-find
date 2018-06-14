window.onscroll = function() {scrollFunction()};

function scrollFunction() {
  if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
    document.getElementById("Btnscroll").style.display = "block";
  } else {
    document.getElementById("Btnscroll").style.display = "none";
  }
}

// When the user clicks on the button, scroll to the top of the document
window.topFunction = function () {
  document.body.scrollTop = 0;
  document.documentElement.scrollTop = 0;
}
