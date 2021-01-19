import { Calendar, whenTransitionDone } from '@fullcalendar/core';
import interactionPlugin from '@fullcalendar/interaction';
import dayGridPlugin from '@fullcalendar/daygrid'

document.addEventListener('turbolinks:load', function() {
    var calendarEl = document.getElementById('calendar');

    var calendar = new Calendar(calendarEl, {
        plugins: [ dayGridPlugin, interactionPlugin ],
        events: '/comfirmed_shifts.json',
        locale: 'ja',
        timeZone: 'Asia/Tokyo',
        scrollTime: '07:00:00',
        headerToolbar: {
            left: '',
            center: 'title',
            right: 'today prev,next' 
        },
        eventClick: function(info){
            var id = info.event.id
            $.ajax({
                type: "GET",
                url:  "/individual_shifts/remove",
                data: { shift_id : id },
                datatype: "html",
            }).done(function(res){
            
            $('.modal-body2').html(res)
            $('#modal2').fadeIn();
            }).fail(function (result) {
                // 失敗処理
                alert("failed");
            });
        }
    });

    calendar.render();
});
