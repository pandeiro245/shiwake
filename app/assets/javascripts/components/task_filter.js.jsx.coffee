@TaskFilter = React.createClass
  propTypes:
    tasks: React.PropTypes.array.isRequired
    handleFilter: React.PropTypes.array.isRequired

  getInitialState: ->
    loading: false
    notice: ''

  handleChange: (e) ->
    tasks = @filterTasks(e.target.value)
    @props.handleFilter(tasks)
    
  handleSaveClick: (e) ->
    e.preventDefault()
    
    keywordNode = React.findDOMNode(@refs.keyword)
    keyword = $(keywordNode).val()
    return unless keyword
    
    params =
      keyword: keyword
    console.log(params)

    @setState(loading: true)
    @setState(notice: '')
    $.ajax
      method: 'POST'
      dataType: 'json'
      url: "/filter_logics"
      data: params
      success: =>
        @setState(notice: '検索条件を保存しました。')
      error: (jqXHR, textStatus, errorThrown) ->
        console.error(jqXHR, textStatus, errorThrown)
        errors = jqXHR.responseJSON
        alert(errors.join('\n'))
      complete: =>
        @setState(loading: false)

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

  render: ->
    notice =  if @state.notice
                `<div className="alert alert-success">
                  <button className="close" type="button" onClick={this.handleNoticeClose}>×</button>
                  {this.state.notice}
                </div>`

    `<div>
      <h3>
        Filter
      </h3>
      <form className="form-inline">
        {notice}
        <div className="form-group">
          <input
            className="form-control"
            type="text"
            ref="keyword"
            placeholder="keyword"
            onChange={this.handleChange}
          />
          <button className="btn btn-default" onClick={this.handleSaveClick}>
            検索条件を保存
          </button>
        </div>
        <div className="form-group">
          <button className="btn btn-default">
            保存した検索条件
          </button>
        </div>
      </form>
    </div>
    `
