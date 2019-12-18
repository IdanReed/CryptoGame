import React from 'react';

import {
  AccountData,
  ContractData,
  ContractForm,
} from '@drizzle/react-components';

import Theme from './theme';

const topBarStyle = {
  ...{
    width: '100%',
    height: '100%',
    backgroundColor: Theme.Colors.darkBg,
  },
  ...Theme.Border
};

class TopBar extends React.Component{
    render() {
      return (
        <div  style={topBarStyle}>

        </div>
      )
    }
}

export default TopBar;