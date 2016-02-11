<h1 class="head"><span class="glyphicon glyphicon-play"></span> Reports
    <a id="collapse-all" title="Delete" class="btn btn-default pull-right"><span class="glyphicon glyphicon-minus"></span> Collapse all</a>
    <a id="expand-all" title="Edit" class="btn btn-default pull-right"><span class="glyphicon glyphicon-plus"></span> Expand all</a>
</h1>
{% if dbsl %}
<ul class="files">
{% for itm in dbsl %}
    {% if authenticatedUser.hasPermission(itm, 'view') %}
    <li>
        <a id="{{ itm.getId() }}_d" class="hide-tree" ><span class="glyphicon glyphicon-minus-sign orange"></span></a> <a>{{ itm.name }} {#<i class="gray">({{ itm.countReports() }} reports)</i>#}</a>
        {% if itm.countReports() %}
            <ul class="{{ itm.getId() }}_dc hide-tree-itm">
                {% for itm2 in itm.getReports() %}
                    {% if authenticatedUser.hasPermission(itm2, 'view') %}
                    <li>
                        <a id="{{ itm2.getId() }}_r" class="hide-tree"><span class="glyphicon glyphicon-minus-sign orange"></span></a> <a>{{ itm2.name }} <i class="gray">({{ itm2.getLogCount() }} logs)</i></a>
                        <table class="table table-hover table-bordered table-striped {{ itm2.getId() }}_rc hide-tree-itm">
                            <thead>
                            <tr>
                                <th class="text-center">Type</th>
                                <th class="text-center">{#<a href="#" style="color: blue"><span class="glyphicon glyphicon-sort-by-attributes"></span>#} Date {#</a>#}</th>
                                <th class="text-center">Time</th>
                                <th class="text-center">Rows</th>
                                <th class="text-center">Download</th>
                            </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td colspan="5" class="gray">
                                        {% if authenticatedUser.hasPermission(itm2, 'run') %}<a href="{{ url('report/runModal', ['id': itm2.getId()]) }}" class="btn btn-success btn-xs runModal"><span class="glyphicon glyphicon-play"></span> Run</a>{% endif %}
                                        <!--<a href="" class="btn btn-default btn-xs runModal"><span class="glyphicon glyphicon-eye-open"></span> Show all</a>-->
                                        &nbsp; <span class="glyphicon glyphicon-time"></span> <i>Next run:
                                            {% if date('Y-m-d H:i:s') < itm2.getJob().getNextRun() %}
                                                <strong class="black">{{utility.formatDate(itm2.getJob().getNextRun())}}</strong>
                                            {% else %}
                                                <strong class="red"> [ not set ] </strong>
                                            {% endif %}
                                        </i>
                                    </td>
                                </tr>
                                {% if itm2.getLogs() %}
                                    {% for itm3 in itm2.getLogs() %}
                                        <tr {% if itm3.errors %}class="red"{% endif %} >
                                            <td class="text-center">
                                                {% if itm3.runType == 'user' %}
                                                    <span class="glyphicon glyphicon-user" title="Run by user"></span>
                                                {% else %}
                                                    <span class="glyphicon glyphicon-time" title="Run by cron"></span>
                                                {% endif %}
                                            </td>
                                            <td class="text-center">{{ utility.formatDate(itm3.startTime) }}</td>
                                            <td class="text-center">{{ itm3.totalTime }} sec</td>
                                            {% if itm3.errors %}
                                                <td class="text-center" colspan="2"><span class=" glyphicon glyphicon-warning-sign" title="{{ itm3.errors }}"></span> Error</td>
                                            {% else %}
                                                <td class="text-center">{{ itm3.rows }} rows</td>
                                                <td class="text-center"><a href="{{ utility.getFile(itm3.fileLocation) }}" target="_blank"><span class="glyphicon glyphicon-save"></span> {{ utility.formatBytes(itm3.fileSize) }}</a></td>
                                            {% endif %}
                                        </tr>
                                    {% endfor %}
                                {% else %}
                                    <tr><td colspan="5" class="text-center" >No reports generated. {% if authenticatedUser.hasPermission(itm2, 'run') %}Generate here: <a href="{{ url('report/runModal', ['id': itm2.getId()]) }}" class="btn btn-success btn-xs runModal"><span class="glyphicon glyphicon-play"></span> Run</a>{% endif %} </td></tr>
                                {% endif %}
                            </tbody>
                        </table>
                    </li>
                    {% endif %}
                {% endfor %}
            </ul>
        {% endif %}
    </li>
    {% endif %}
{% endfor %}
</ul>
{% else %}
    <h3 class="red">Not reports available!</h3>
{% endif %}
<script>
    var hideTree = [];
    $('.runModal').click(function(e){
        $.get($(this).attr('href'), function(data){
            $('#loadModal').empty().html(data);
        });
        e.preventDefault();
    });

    $('.hide-tree').click(function(){
        var objC = $('.' + $(this).attr('id')+'c');
        if(objC.is(":visible")) {
            $(this).find('.glyphicon').removeClass('glyphicon-minus-sign').addClass('glyphicon-plus-sign').attr('title', 'Expand');
            objC.hide();
        }else{
            $(this).find('.glyphicon').removeClass('glyphicon-plus-sign').addClass('glyphicon-minus-sign').attr('title', 'Collapse');
            objC.show();
        }
        return false;
    });

    $('#collapse-all, #expand-all').click(function(){
        if($(this).attr('id') == 'collapse-all'){
            $('.hide-tree .glyphicon').removeClass('glyphicon-minus-sign').addClass('glyphicon-plus-sign').attr('title', 'Expand');
            $('.hide-tree-itm').hide();
        }else{
            $('.hide-tree .glyphicon').removeClass('glyphicon-plus-sign').addClass('glyphicon-minus-sign').attr('title', 'Collapse');
            $('.hide-tree-itm').show();
        }
        return false;
    });
</script>