$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type == "open") {
            Radio.SlideUp()
        }

        if (event.data.type == "close") {
            Radio.SlideDown()
        }

        if (event.data.type == "update") {
            $("#channel").val(event.data.putanginamo)
        }
		
    });

    document.onkeyup = function (data) {
        if (data.which == 27) { // Escape key
            $.post('https://a-radio/escape', JSON.stringify({}));
            Radio.SlideDown()
        } else if (data.which == 13) { // Enter key
            $.post('https://a-radio/joinRadio', JSON.stringify({
                channel: $("#channel").val()
            }));
        }
    };
});

Radio = {}

$(document).on('click', '#submit', function(e){
    e.preventDefault();

    $.post('https://a-radio/joinRadio', JSON.stringify({
        channel: $("#channel").val()
    }));
});

$(document).on('click', '#disconnect', function(e){
    e.preventDefault();

    $.post('https://a-radio/leaveRadio');
});

$(document).on('click', '#volumeUp', function(e){
    e.preventDefault();

    $.post('https://a-radio/volumeUp', JSON.stringify({
        channel: $("#channel").val()
    }));
});

$(document).on('click', '#volumeDown', function(e){
    e.preventDefault();

    $.post('https://a-radio/volumeDown', JSON.stringify({
        channel: $("#channel").val()
    }));
});

$(document).on('click', '#decreaseradiochannel', function(e){
    e.preventDefault();

    $.post('https://a-radio/decreaseradiochannel', JSON.stringify({
        channel: $("#channel").val()
    }));
});

$(document).on('click', '#increaseradiochannel', function(e){
    e.preventDefault();

    $.post('https://a-radio/increaseradiochannel', JSON.stringify({
        channel: $("#channel").val()
    }));
});

$(document).on('click', '#poweredOff', function(e){
    e.preventDefault();

    $.post('https://a-radio/poweredOff', JSON.stringify({
        channel: $("#channel").val()
    }));
});

Radio.SlideUp = function() {
    $(".container").css("display", "block");
    $(".radio-container").animate({bottom: "6vh",}, 250);
}

Radio.SlideDown = function() {
    $(".radio-container").animate({bottom: "-110vh",}, 400, function(){
        $(".container").css("display", "none");
    });
}
