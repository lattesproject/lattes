$(document).ready(function() {

    /*start of levenshtein function*/

    var levenshtein = function(min, split) {
        // Levenshtein Algorithm Revisited - WebReflection
        try {
            split = !("0")[0]
        } catch (i) {
            split = true
        };

        return function(a, b) {
            if (a == b)
                return 0;
            if (!a.length || !b.length)
                return b.length || a.length;
            if (split) {
                a = a.split("");
                b = b.split("")
            };
            var len1 = a.length + 1,
                len2 = b.length + 1,
                I = 0,
                i = 0,
                d = [
                    [0]
                ],
                c, j, J;
            while (++i < len2)
                d[0][i] = i;
            i = 0;
            while (++i < len1) {
                J = j = 0;
                c = a[I];
                d[i] = [i];
                while (++j < len2) {
                    d[i][j] = min(d[I][j] + 1, d[i][J] + 1, d[I][J] + (c != b[J]));
                    ++J;
                };
                ++I;
            };
            return d[len1 - 1][len2 - 1];
        }
    }(Math.min, false);


    /*end of the levenshtein function */




    /*acumulate the manual pontuation for article in this variable*/
    var article_total_points_suggestion = 0;
    var summarized_total_points_suggestion = 0;
    var completed_work_total_points_suggestion = 0;
    var event_json;
    get_event_json($('#hidden_event_id').val());
    var periodic_json = loadPeriodicJson();

    $(".form-group").on('click', '.add-categoria', function() {

        formGroup = $('<div class="row form-group"><div class="col-sm-offset-2"></div></div>');
        itemLabel = $('<div class="col-sm-4"><label class="control-label"></label></div>');
        itemField = $('<div class="col-sm-2"><input class="form-control" placeholder="valor"></div>');
        itemMax = $('<div class="col-sm-2"><input class="form-control" placeholder="máximo"></div>');
        removeButton = $('<a value="livro" class="remove-categoria btn btn-danger btn-sm"><span class="glyphicon glyphicon-remove"></span></a>');

        itemAttrId = $(this).attr("id");
        itemAttrName = $(this).attr("name");

        itemLabel.children().text($(this).text());

        itemField.children().attr("id", itemAttrId);
        itemField.children().attr("name", itemAttrName);

        itemMax.children().attr("id", (itemAttrId + "_max"));
        itemMax.children().attr("name", (itemAttrName.replace("]", "_max]")));

        formGroup.children().append(itemLabel).append(itemField).append(itemMax).append(removeButton);
        $(this).parents(".form-group").before(formGroup);

        //desabilitar o botão quando não existem opções para adicionar
        if ($(this).parent().children().length == 1) {
            $(this).parent().siblings(".btn.btn-default.dropdown-toggle").addClass("disabled");
        }

        $(this).remove();
    });

    //desabilita o botão adicionar caso ele não tenha opções disponíveis
    $(".list-categorias").each(function() {
        if ($(this).children().length == 0) {
            $(this).siblings(".btn.btn-default.dropdown-toggle").addClass("disabled");
        }
    });

    $(".form-horizontal").on('click', '.remove-categoria', function() {
        itemValue = $(this).attr("value");
        addItemButton = $('<li class="add-categoria"><a></a></li>');

        itemAttrId = $(this).parent().find(".col-sm-2:first").children().attr("id");
        itemAttrName = $(this).parent().find(".col-sm-2:first").children().attr("name");
        itemLabel = $(this).siblings(".col-sm-4").text();

        addItemButton.attr("id", itemAttrId);
        addItemButton.attr("name", itemAttrName);
        addItemButton.children().text(itemLabel);

        $(this).parents(".grupo").find(".list-categorias").append(addItemButton);

        $(this).parents(".grupo").find(".btn.btn-default.dropdown-toggle").removeClass("disabled");

        $(this).parents(".form-group").remove();
    });

    /*brings the qualis category value from the option selected on the candidates page*/
    $('.select_qualis').on("change", function(e) {
        if ($(this).find("option:selected").text() != 'Sugestão') {
            $(this).closest('td').prev().text($(this).find("option:selected").attr('qualis'));
        } else {
            $(this).closest('td').prev().text('');
        }
    });


    /*manual through suggestions*/
    $('.article_no_found_total_points_suggestion').on("click", function() {
        if ($(this).closest('td').prev().find("option:selected").text() != "Sugestão") {
            if ($(this).text() == "Aceitar") {
                $(this).closest('td').prev().find('select').attr("disabled", true);
                $(this).text("Cancelar");
                $(this).closest('td').next().next().find('button').attr("disabled", true);
                $(this).closest('td').next().find('input').attr("disabled", true);


                if ($(this).attr("name") == "#total_article_not_found_value") {
                    /* how much each value worth */
                    article_total_points_suggestion = (parseFloat(article_total_points_suggestion) +
                        parseFloat($(this).closest('td').prev().find("option:selected").attr('value'))).toFixed(2);

                }


                if ($(this).attr("name") == "#total_summarized_work_not_found_value") {
                    /* how much each value worth */
                    summarized_total_points_suggestion = (parseFloat(summarized_total_points_suggestion) +
                        parseFloat($(this).closest('td').prev().find("option:selected").attr('value'))).toFixed(2);

                }

                if ($(this).attr("name") == "#total_completed_work_not_found_value") {
                    /* how much each value worth */
                    completed_work_total_points_suggestion = (parseFloat(completed_work_total_points_suggestion) +
                        parseFloat($(this).closest('td').prev().find("option:selected").attr('value'))).toFixed(2);

                }


                //adding result to total result at the top of the page 
                $('#candidate_total_geral').val((parseFloat($('#candidate_total_geral').val()) +
                    parseFloat($(this).closest('td').prev().find("option:selected").attr('value'))).toFixed(2));

            } else {
                $(this).text("Aceitar");
                $(this).closest('td').prev().find('select').attr("disabled", false);
                $(this).closest('td').next().next().find('button').attr("disabled", false);
                $(this).closest('td').next().find('input').attr("disabled", false);
                article_total_points_suggestion = (parseFloat(article_total_points_suggestion) -
                    parseFloat($(this).closest('td').prev().find("option:selected").attr('value'))).toFixed(2);

                //adding result to total result at the top of the page 
                $('#candidate_total_geral').val((parseFloat($('#candidate_total_geral').val()) -
                    parseFloat($(this).closest('td').prev().find("option:selected").attr('value'))).toFixed(2));
            }
            // $('#article_no_found_total_points').text(article_total_points_suggestion);

            if ($(this).attr("name") == "#total_article_not_found_value") {
                $($(this).attr("name")).text(article_total_points_suggestion);
            }

            if ($(this).attr("name") == "#total_summarized_work_not_found_value") {
                $($(this).attr("name")).text(summarized_total_points_suggestion);
            }

            if ($(this).attr("name") == "#total_completed_work_not_found_value") {
                $($(this).attr("name")).text(completed_work_total_points_suggestion);
            }

        } else {
            alert("Selecione uma opção");
        }
    });


    /*manual calculation through the input field*/
    $('.manual_calculation').on("click", function() {
        //get what is in the input box and put in the variable validate_manual_field
        var validate_manual_field = parseFloat($(this).closest('td').prev().find('input').val());
        //verify if this value is negative or anything but a number
        if (!isNaN(validate_manual_field) && validate_manual_field >= 0) {
            /*is the name "confirmar?" change it to "cancelar"*/
            if ($(this).text() == "Confirmar") {
                $(this).text("Cancelar");
                /*disable all other fields until the name come back to "confirmar"*/
                $(this).closest('td').prev().prev().find('button').attr("disabled", true);
                $(this).closest('td').prev().prev().prev().find('select').attr("disabled", true);
                $(this).closest('td').prev().find('input').attr("disabled", true);


                if ($(this).attr("name") == "#total_article_not_found_value") {
                    article_total_points_suggestion = (parseFloat(article_total_points_suggestion) +
                        validate_manual_field).toFixed(2);
                }

                if ($(this).attr("name") == "#total_summarized_work_not_found_value") {

                    summarized_total_points_suggestion = (parseFloat(summarized_total_points_suggestion) +
                        validate_manual_field).toFixed(2);

                }

                if ($(this).attr("name") == "#total_completed_work_not_found_value") {
                    completed_work_total_points_suggestion = (parseFloat(completed_work_total_points_suggestion) +
                        validate_manual_field).toFixed(2);
                }



                //adding result to total result at the top of the page 
                $('#candidate_total_geral').val((parseFloat($('#candidate_total_geral').val()) +
                    validate_manual_field).toFixed(2));

            } else {
                $(this).text("Confirmar");
                $(this).closest('td').prev().prev().find('button').attr("disabled", false);
                $(this).closest('td').prev().prev().prev().find('select').attr("disabled", false);

                if ($(this).attr("name") == "#total_article_not_found_value") {
                    article_total_points_suggestion = (parseFloat(article_total_points_suggestion) -
                        validate_manual_field).toFixed(2);
                }

                if ($(this).attr("name") == "#total_summarized_work_not_found_value") {

                    summarized_total_points_suggestion = (parseFloat(summarized_total_points_suggestion) -
                        validate_manual_field).toFixed(2);

                }

                if ($(this).attr("name") == "#total_completed_work_not_found_value") {
                    completed_work_total_points_suggestion = (parseFloat(completed_work_total_points_suggestion) -
                        validate_manual_field).toFixed(2);
                }
                //adding result to total result at the top of the page 
                $('#candidate_total_geral').val((parseFloat($('#candidate_total_geral').val()) -
                    validate_manual_field).toFixed(2));
                $(this).closest('td').prev().find('input').attr("disabled", false);
            }

            if ($(this).attr("name") == "#total_article_not_found_value") {
                $($(this).attr("name")).text(article_total_points_suggestion);
            }

            if ($(this).attr("name") == "#total_summarized_work_not_found_value") {
                $($(this).attr("name")).text(summarized_total_points_suggestion);
            }

            if ($(this).attr("name") == "#total_completed_work_not_found_value") {
                $($(this).attr("name")).text(completed_work_total_points_suggestion);
            }

        } else {
            alert('Entre uma pontuação válida');
        }
    });


    /*Makes datepicker show only the year*/
    $(".datepicker").datepicker({
        format: " yyyy", //see there is extra space in format, dont remove it
        viewMode: "years",
        minViewMode: "years"
    });


    function loadPeriodicJson(){
        $.getJSON('/periodico.json', function(data) {
            periodic_json = data; 
            //console.log(periodic_json);
        });
    }

   
    
    
    $("#load_suggestion").on('click', function() {
      console.log(event_json);
      //get all td's with this class and iterate through them
      $(".article_title").each(function() {
         $td_value = $(this);
          suggestions = new Array();
        //compare each entrance to each value inside of the json file
          Object.keys(periodic_json.periodico).forEach(function(key,value){

                       levenshtein_distance = levenshtein(key, $td_value.context.textContent);
                       if(levenshtein_distance<27){
                         var articles_hash = {};
                          articles_hash['dif'] = levenshtein_distance;
                          articles_hash['periodic'] = key;
                          articles_hash['qualis'] = periodic_json['periodico'][key];
                          articles_hash['value'] =  qualis_point(periodic_json['periodico'][key], "artigos");
                          suggestions.push(articles_hash);
                       }
          });
          //find the select object in each line
          $select = $(this).closest('td').next().next().next().find("select");
          var $option;
          
          //this will sort the object array by the dif number
          suggestions.sort(function(a, b) {
              return parseFloat(a.dif) - parseFloat(b.dif);
          });

          //limit the number of suggestions to 10
          if(suggestions.length>10)
          suggestions.length = 10;

          //clear the selec box
          $select.empty();
          $select.prepend("<option  selected='selected'>Sugestão</option>");
          suggestions.forEach(function(val) {
              $option = $('<option qualis="' + val.qualis + '" + value="' + val.value + '" dif="' + val.dif + '" >' + val.periodic + '</option>');
                      
                     //just if you want to make this option selected by default
                    //$option.attr('selected', 'selected');
                

                $select.append($option);
          });

      });
    });

    

    //event id number
    //var event_id_number = $('#hidden_event_id').val();
  function get_event_json(event_id_number){
      $.ajax({
          type: "GET",
          url: "/events/" + event_id_number + "/json",
          dataType: "json",
          success: function(data) {
              event_json = data;
          }
      });
  }



  function qualis_point(qualis, entity){
    var string_qualis_entity = entity + "_qualis_" + qualis.toLowerCase();
    return event_json[string_qualis_entity];
  }

});