// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require jquery.colorbox

function check_for_enter_pressed(e){
  if (e.keyCode == 13)
    return true;
  
  return false;
}

function isArrowKeyPressed(e){
  var evt = e || window.event;
  if(evt.keyCode >= 37 && evt.keyCode <= 40){
    return true;
  }
  return false;
}


function validate_question(){
    if($('#question_nature_list').val() == 'Objective'){
        

        var count = 0;
        var checked = false;
        if($('textarea[name="objective_options[0][statement]"]').val().length > 0){
                    count = count + 1;
                    if($('#question_answers_0_checkbox:checked').length > 0){
                        checked = true
                    }
        }
        if($('textarea[name="objective_options[1][statement]"]').val().length > 0){
                    count = count + 1;
                    if($('#question_answers_1_checkbox:checked').length > 0){
                        checked = true
                    }
        }
        if($('textarea[name="objective_options[2][statement]"]').val().length > 0){
                    count = count + 1;
                    if($('#question_answers_2_checkbox:checked').length > 0){
                        checked = true
                    }
        }
        if($('textarea[name="objective_options[3][statement]"]').val().length > 0){
                    count = count + 1;
                    if($('#question_answers_3_checkbox:checked').length > 0){
                        checked = true
                    }
        }
        if($('textarea[name="objective_options[4][statement]"]').val().length > 0){
                    count = count + 1;
                    if($('#question_answers_4_checkbox:checked').length > 0){
                        checked = true
                    }
        }



        if(count<2){
           alert("Atleast two options must be filled");
            return false;
        }

        if(!checked){
            alert("Atleast one answer must be correct one");
            return false;
        }

    }else if($('#question_nature_list').val() == 'Subjective'){
        if($('#subjectiveAnswer').val().length<= 0)
        {    alert("Answer is compulsary");
            return false;
        }

    }
    return true;

}