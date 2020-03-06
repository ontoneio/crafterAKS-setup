var xmlHttp;
function srvTime() {
  try {
    //FF, Opera, Safari, Chrome
    xmlHttp = new XMLHttpRequest();
  }
  catch (err1) {
    //IE
    try {
      xmlHttp = new ActiveXObject('Msxml2.XMLHTTP');
    }
    catch (err2) {
      try {
        xmlHttp = new ActiveXObject('Microsoft.XMLHTTP');
      }
      catch (eerr3) {
        //AJAX not supported, use CPU time.
        alert("AJAX not supported");
      }
    }
  }
  xmlHttp.open('HEAD',window.location.href.toString(),false);
  xmlHttp.setRequestHeader("Content-Type", "text/html");
  xmlHttp.send('');
  return xmlHttp.getResponseHeader("Date");
}

$(document).ready(function () {
  // tabs
  $('.tabs.tabs-top, .tabs.tabs-circle-top, .tabs.tabs-2-big-top').easytabs({
    animationSpeed: 200,
    updateHash: false
  });

  // image hover
  $('.icon-overlay a').prepend('<span class="icn-more"></span>');



  // reveal animations
  var animation_down = {
    origin: 'top',
    scale: 1,
    duration: 750,
    delay: 100,
  };
  var animation_up = {
    origin: 'bottom',
    scale: 1,
    duration: 750,
    delay: 100,
  };
  sr.reveal('.reveal-down', animation_down);
  sr.reveal('.reveal-down-seq', animation_down, 200);
  sr.reveal('.reveal-up', animation_up);
  sr.reveal('.reveal-up-seq', animation_up, 200);
  sr.reveal('.reveal-up-seq_services', animation_up, 200);

  //current year
  $('.js-year').html(new Date(srvTime()).getFullYear());

  // GovDelivery
  $('input[type="radio"]').change(function() {
    $(".input-group__email").toggle();
    $(".input-group__phone").toggle();
  });
});