import { Calendar, whenTransitionDone } from '@fullcalendar/core';
import interactionPlugin from '@fullcalendar/interaction';
import weekGridPlugin from '@fullcalendar/timegrid'
//import dayGridPlugin from '@fullcalendar/daygrid'

document.addEventListener('turbolinks:load', function() {
    var calendarEl = document.getElementById('calendar');

    var calendar = new Calendar(calendarEl, {
        plugins: [ weekGridPlugin, interactionPlugin ],
        events: '/deletable_shifts.json',
        locale: 'ja',
        timeZone: 'Asia/Tokyo',
        scrollTime: '07:00:00',
        firstDay: 1,
        headerToolbar: {
            start: '',
            center: 'title',
            end: 'today prev,next' 
        },
        buttonText: {
            today: '今日'
        }, 
        allDayText: '営業 催事',
        height: "auto",
        eventClick: function(info){
            var id = info.event.id
            $.ajax({
                type: "GET",
                url:  "/deletable_shifts/restore",
                data: { shift_id : id },
                datatype: "html",
            }).done(function(res){
            
            $('.modal-body').html(res)
            $('#modal').fadeIn();
            }).fail(function (result) {
                // 失敗処理
                alert("failed");
            });
        },
        eventClassNames: function(arg){
            if(arg.event.allDay){
                return [ 'horizon' ]
            }else{
                return [ 'vertical' ]
            }
        }
    });

    calendar.render();

    $('button.reload').click(function(){
        calendar.refetchEvents();
    });
});