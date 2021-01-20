import { Calendar, whenTransitionDone } from '@fullcalendar/core';
import interactionPlugin from '@fullcalendar/interaction';
import weekGridPlugin from '@fullcalendar/timegrid'
import { event } from 'jquery';
//import dayGridPlugin from '@fullcalendar/daygrid'

document.addEventListener('turbolinks:load', function() {
    var calendarEl = document.getElementById('calendar');

    var calendar = new Calendar(calendarEl, {
        plugins: [ weekGridPlugin, interactionPlugin ],
        events: '/perfect_shifts.json',
        locale: 'ja',
        timeZone: 'Asia/Tokyo',
        scrollTime: '07:00:00',
        headerToolbar: {
            left: '',
            center: 'title',
            right: 'today prev,next' 
        },
        height: "auto",
        eventClassNames: function(arg){
            if(arg.event.allDay){
                return [ 'horizon' ]
            }else{
                return [ 'vertical' ]
            }
        },
        eventClick: function(info){
            var id = info.event.id

            if(info.el.style.backgroundColor == "yellow"){
                $.ajax({
                    type: "GET",
                    url:  "/perfect_shifts/fill",
                    data: { shift_id : id },
                    datatype: "html",
                }).done(function(res){
                
                    $('.modal-body').html(res)
                    $('#modal').fadeIn();
                }).fail(function (result) {
                    // 失敗処理
                    alert("failed");
                });
            }
        }
    });
    calendar.render();
});