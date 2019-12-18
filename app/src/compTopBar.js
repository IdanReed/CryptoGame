import React from 'react';

import {
  AccountData,
  ContractData,
  ContractForm,
} from '@drizzle/react-components';

import Theme from './theme';

const topBarStyle = {
  ...{
    display: 'flex',
    justifyContent: 'flex-start',
    alignItems: 'center',
    height: '50px',
    width: '100%',
    backgroundColor: Theme.Colors.lightBg,
  },
  ...Theme.Border,
};

const sectorRootHeight = '20px';

class SectorRootForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = {value: '12345'};

    this.handleChange = this.handleChange.bind(this);
  }

  handleChange(event) {
    this.setState({value: event.target.value});
  }

  render() {
    return (
      <form onSubmit={this.handleSubmit}>
        <label>
          Sector:
          <input
            type="text"
            value={this.state.value}
            onChange={this.handleChange}
            style={
              {
                ...{
                  height:{sectorRootHeight},
                  backgroundColor: Theme.Colors.topBg,
                },
                ...Theme.Border,
              }
            }
          />
        </label>
      </form>
    )
  }
}

class TopBar extends React.Component{
    render() {
      return (
        <div className="felxContainer" style={topBarStyle}>
          <div className="gridItem">
            <SectorRootForm />
          </div>
        </div>
      )
    }
}

export default TopBar;