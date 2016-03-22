@TaskFilter = React.createClass
  propTypes:
    tasks: React.PropTypes.array.isRequired
    handleFilter: React.PropTypes.array.isRequired

  getInitialState: ->
    notice: ''
    filterLogics:[]

  componentWillMount: ->
    @listFilterLogics()

  handleChange: (e) ->
    tasks = @filterTasks(e.target.value)
    @props.handleFilter(tasks)
    
  handleSelectFilter: (e) ->
    keyword = e.target.text
    keywordNode = React.findDOMNode(@refs.keyword)
    keywordNode.value = keyword
    
    tasks = @filterTasks(keyword)
    @props.handleFilter(tasks)
    
  handleSaveClick: (e) ->
    e.preventDefault()
    keywordNode = React.findDOMNode(@refs.keyword)
    keyword = $(keywordNode).val()
    return unless keyword
    
    params =
      keyword: keyword
    @setState(notice: '')
    $.ajax
      method: 'POST'
      dataType: 'json'
      url: "/filter_logics"
      data: params
      success: (jqXHR, textStatus) =>
        console.log(jqXHR)
        console.log(textStatus)
        if jqXHR.errors
          @setState(notice: jqXHR.errors)
        else
          @setState(notice: '検索条件を保存しました。')
          @listFilterLogics()
      error: (jqXHR, textStatus, errorThrown) =>
        console.error(jqXHR, textStatus, errorThrown)
        errors = jqXHR.responseJSON
        alert(errors.join('\n'))

  handleNoticeClose: (e) ->
      @setState(notice: '')

  filterTasks: (filterText) ->
    filterText = filterText.toLowerCase();
    if !filterText
      @props.tasks
    else
      @props.tasks.filter (task) =>
        task.title.toLowerCase().indexOf(filterText) != -1 ||
        task.url.toLowerCase().indexOf(filterText) != -1
  
  listFilterLogics: ->
    $.ajax
      method: 'GET'
      dataType: 'json'
      url: "/filter_logics"
      success:(jqXHR, textStatus) =>
        console.log(jqXHR)
        @setState(filterLogics: jqXHR)
      error: (jqXHR, textStatus, errorThrown) =>
        console.error(jqXHR, textStatus, errorThrown)
        errors = jqXHR.responseJSON
        alert(errors.join('\n'))

  render: ->
    notice =  if @state.notice
                `<div className="alert alert-success">
                  <button className="close" type="button" onClick={this.handleNoticeClose}>×</button>
                  {this.state.notice}
                </div>`

    filterNodes = @state.filterLogics.map (filterLogic) =>
      `<li><a href="#" onClick={_this.handleSelectFilter}>{filterLogic.keyword}</a></li>`

    `<div>
      <h3>
        Filter
      </h3>
      <form className="form-inline">
        {notice}
        <div className="input-group">
          <input
            className="form-control"
            type="text"
            ref="keyword"
            placeholder="keyword"
            onChange={this.handleChange}
          />
          <span className="input-group-btn">
            <button className="btn btn-default" onClick={this.handleSaveClick}>
              検索条件を保存
            </button>
            <button type="button" className="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
              保存した検索条件 <span className="caret"></span>
            </button>
            <ul className="dropdown-menu">
              {filterNodes}
            </ul>
          </span>
        </div>
      </form>
    </div>
    `
