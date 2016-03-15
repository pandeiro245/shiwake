@TaskList = React.createClass
  propTypes:
    initialTasks: React.PropTypes.array.isRequired
    teamId: React.PropTypes.number.isRequired

  getInitialState: ->
    tasks: @props.initialTasks
    parents: []
    loading: false

  componentDidUpdate: ->
    $('.select-parent.multi').select2(
      width: 900
    )

  handleSaveItem: ->
    @fetchParents()

  componentWillMount: ->
    @fetchParents()

  fetchParents: ->
    @setState(loading: true)
    $.ajax
      method: 'GET'
      dataType: 'json'
      url: "/teams/#{@props.teamId}/tasks"
      success: (data) =>
        @setState(parents: data)
      error: (jqXHR, textStatus, errorThrown) ->
        alert("#{textStatus}\n#{errorThrown}")
        @setState(editing: false)
      complete: =>
        @setState(loading: false)

  render: ->
    unless @state.parents.length
      return `<div><i className="fa fa-fw fa-spinner fa-pulse fa-lg"></i></div>`

    spinner = if @state.loading
                `<small>&nbsp;<i className="fa fa-fw fa-spinner fa-pulse text-muted"></i></small>`
              else
                `<span></span>`

    itemNodes = @state.tasks.map (task) =>
      props =
        task: task
        onSave: @handleSaveItem
        parents: @state.parents
        teamId: @props.teamId
        options: url2options(task.url)
      `<TaskItem {...props} key={task.id} />`
    
    parentsNode = @state.parents.map (parent) =>
      `<option value={parent.id} key={parent.id}>{parent.id}: {parent.label}</option>`

    `<div>
      <h3>Multi Update</h3>
      <table className="table table-hover">
      <tr>
        <td>
          <select className="select-parent multi" ref="parent">
            <option></option>
            {parentsNode}
          </select>
        </td>
        <td className="text-nowrap">
          <button className="btn btn-primary btn-sm" onClick={this.handleSaveClick}>
            <i className="fa fa-fw fa-check"></i>
          </button>
        </td>
      </tr>
      </table>
      <h3>
        Uncategorized tasks
        {spinner}
      </h3>
      <table className="table table-hover">
        {itemNodes}
      </table>
    </div>`

url2options = (url) ->
  res = []
  for filter in window.filters
    if url.match(filter.pattern)
      res = filter.options.split(',').map (id) =>
        parseInt(id)
  res

