import React, { Component } from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import _ from "lodash"
import moment from "moment"
import DatePicker from "react-datepicker"

class MeetingScheduleForm extends Component {
  static propTypes = {
    team_member_id: PropTypes.number.isRequired,
    team_member_user: PropTypes.object.isRequired,
  }

  constructor(props) {
    super(props)
    this.state = {
      startTime: moment(),
      frequency: "",
    }
  }

  getDayOfWeek = (date) => {
    return moment(date).format("dddd").toLowerCase()
  }

  getDayOfMonth = (date) => {
    return Math.ceil(moment(date).date() / 7)
  }

  handleDateChange = (date) => {
    this.setState({
      startTime: date
    })
  }

  handleSelectFrequency = (e) => {
    const frequency = e.target.value
    this.setState({
      frequency: frequency
    })
  }

  getFrequencyForSubmit = () => {
    const parts = this.state.frequency.split("-")
    return parts[1]
  }

  getEveryForSubmit = () => {
    const parts = this.state.frequency.split("-")
    if (parts[1] === "week") {
      return parts[0]
    } else {
      return this.getDayOfMonth(this.state.startTime)
    }
  }

  handleSubmitSchedule = () => {
    let data = {
      meeting_schedule: {
        start_time: moment(this.state.startTime).format("YYYY-MM-DDTHH:mm:ssZ"),
        frequency: this.getFrequencyForSubmit(),
        every: this.getEveryForSubmit(),
        day_of_week: this.getDayOfWeek(this.state.startTime),
      }
    }

    $.ajax({
      url: `/team_members/${this.props.team_member_id}/meeting_schedules`,
      type: "POST",
      data: data,
      success: (data) => {
        console.log(data)
      },
      error: (error) => {
        console.log(error)
      }
    })
  }

  render() {
    const name = `${this.props.team_member_user.first_name} ${this.props.team_member_user.last_name}`
    return (
      <div className="card">
        <div className="card-body">
          <div className="card-subtitle">{`Schedule your one-on-one with ${name}`}</div>
          <div>
            <DatePicker
              selected={this.state.startTime}
              onChange={this.handleDateChange}
              minDate={moment()}
              placeholderText="Click to select a date"
            />
            <div className="form-group">
              <label htmlFor="frequencySelect">every:</label>
              <select className="form-control" id="frequencySelect" value={this.state.frequency} onChange={this.handleSelectFrequency}>
                <option value="">Choose a value</option>
                <option value="1-week">Weekly</option>
                <option value="2-week">Every 2 Weeks</option>
                <option value="3-week">Every 3 Weeks</option>
                <option value="4-week">Every 4 Weeks</option>
                <option value="1-month">Monthly (Day of the Month)</option>
              </select>
            </div>
            <button className="btn btn-primary float-right" onClick={this.handleSubmitSchedule}>Submit</button>
          </div>
        </div>
      </div>
    )
  }
}

const renderComponent = () => {
  const node = document.getElementById("team-member-data")
  const teamMemberId = JSON.parse(node.getAttribute("data-team-member-id"))
  const teamMemberUser = JSON.parse(node.getAttribute("data-team-member-user"))
  ReactDOM.render(
    <MeetingScheduleForm team_member_id={teamMemberId} team_member_user={teamMemberUser} />,
    document.getElementById("new_meeting_schedule_form"),
  )
}

if (document.readyState === "complete") {
  renderComponent()
} else {
  document.addEventListener('DOMContentLoaded', renderComponent)
}
