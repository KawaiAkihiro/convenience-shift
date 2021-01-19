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
        }
    });
    calendar.render();
});