import React, { Component } from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import _ from "lodash"

class NewTeamMember extends Component {
  static propTypes = {
    available_people: PropTypes.array,
    team_id: PropTypes.number,
  }

  constructor(props) {
    super(props)
    this.state = {
      searchTerm: "",
      firstName: "",
      lastName: "",
      email: "",
      selectedUserId: ""
    }
  }

  updateSearchTerm = (e) => {
    let term = e.target.value
    this.setState({
      searchTerm: term
    })
  }

  getMatchingPeople = () => {
    return this.props.available_people.filter(person => {
      return this.state.searchTerm.length > 0 &&
      (person.first_name.match(this.state.searchTerm) || person.last_name.match(this.state.searchTerm))
    })
  }

  updateSelectedUser = (user) => {
    this.setState({
      selectedUserId: user.id,
      searchTerm: "",
      firstName: user.first_name,
      lastName: user.last_name,
      email: user.email,
    })
  }

  handleUserValueChange = (key,e) => {
    let value = e.target.value

    this.setState({
      [key]: value
    })
  }

  renderMatchingPeople = () => {
    let matches = this.getMatchingPeople()

    if (matches.length > 0) {
      return (
        <div
          className="dropdown-menu position-absolute show"
          style={{transform: "translate3d(0px, 68px, 0px)", top: 0, left: 0, willChange: "transform", width: "100%" }}
        >
          {matches.map(match => {
            return (
              <div
                key={match.id}
                className="dropdown-item"
                onClick={this.updateSelectedUser.bind(null, match)}
              >
                {`${match.first_name} ${match.last_name}`}
              </div>
            )
          })}
        </div>
      )
    } else if (this.state.searchTerm.length > 0) {
      return (
      <div
        className="dropdown-menu position-absolute show"
        style={{transform: "translate3d(0px, 68px, 0px)", top: 0, left: 0, willChange: "transform", width: "100%" }}
      >
        <div className="dropdown-item">No user matches your search</div>
      </div>
      )
    }
  }

  render() {
    return (
    <div>
      <div className="form-group position-relative">
        <label htmlFor="existingUserSearch">Search for an existing user or add a new one:</label>
        <input
          type="search"
          className="form-control"
          id="existingUserSearch"
          onChange={this.updateSearchTerm}
          value={this.state.searchTerm}
        />
        {this.renderMatchingPeople()}
      </div>
      <div>
        <input type="hidden" name="team_member[user_id]" value={this.state.selectedUserId} />
        <div className="form-group">
          <label htmlFor="userFirstName">First Name:</label>
          <input
            type="text"
            className="form-control"
            id="userFirstName"
            name="team_member[first_name]"
            placeholder="John"
            value={this.state.firstName}
            onChange={this.handleUserValueChange.bind(null, "firstName")}
          />
        </div>
        <div className="form-group">
          <label htmlFor="userLastName">Last Name:</label>
          <input
            type="text"
            className="form-control"
            id="userLastName"
            name="team_member[last_name]"
            placeholder="Sample"
            value={this.state.lastName}
            onChange={this.handleUserValueChange.bind(null, "lastName")}
          />
        </div>
        <div className="form-group">
          <label htmlFor="userEmail">Email:</label>
          <input
            type="email"
            className="form-control"
            id="userEmail"
            name="team_member[email]"
            placeholder="johnsample@example.com"
            value={this.state.email}
            onChange={this.handleUserValueChange.bind(null, "email")}
            required
          />
          <div className="invalid-feedback">
            Please provide a valid email address.
          </div>
        </div>
        <div className="form-check form-check-inline">
          <label className="form-check-label">
            <input type="hidden" name="team_member[role]" value="employee" />
            <input
              className="form-check-input"
              type="checkbox"
              id="inlineCheckbox1"
              name="team_member[role]"
              value="manager"
            />
              Make manager
          </label>
        </div>
      </div>
    </div>
    )
  }
}

const renderComponent = () => {
  const node = document.getElementById("new-team-member-data")
  const availablePeopleData = JSON.parse(node.getAttribute("data-available-people"))
  const teamIdData = JSON.parse(node.getAttribute("data-team-id"))

  ReactDOM.render(
    <NewTeamMember available_people={availablePeopleData} team_id={teamIdData} />,
    document.getElementById("new_team_member_form"),
  )
}

if (document.readyState === "complete") {
  renderComponent()
} else {
  document.addEventListener('DOMContentLoaded', renderComponent)
}
