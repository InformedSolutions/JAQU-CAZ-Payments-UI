import "jquery"

window.onload = function () {
    $("#back").removeClass('visually-hidden')
    $("#back").removeClass('aria-hidden')

    $("#back").click(function(event) {
        event.preventDefault();
        history.back(1);
    });
};