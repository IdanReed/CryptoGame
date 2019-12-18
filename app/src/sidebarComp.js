import React from 'react';

import {
  AccountData,
  ContractData,
  ContractForm,
} from '@drizzle/react-components';

import Theme from './colorSet';

const sideBarStyle = {
  ...{
    position: 'absolute',
    padding: '10px',
    top: '0px',
    right: '0px',
    height: '100%',
    width: '20%',
    backgroundColor: Theme.Colors.lightBg,
  },
  ...Theme.Border
};

class SideBar extends React.Component{
  render() {
    return (
      <div className='SideBar' style={sideBarStyle}>
        <SidebarBox>
          <SectorInfo/>
        </SidebarBox>
        <SidebarBox>
          <SectorInfo/>
        </SidebarBox>
      </div>
    )
  }
}

const sidebarBoxStyle = {
  ...{
    position: 'relative',
    marginBottom: "10px",
    height: '200px',
    width: '100%',
    top: '0px',
    backgroundColor: Theme.Colors.topBg,
    boxSizing: 'border-box',
  },
  ...Theme.Border
};

function SidebarBox(props){
  return (
      <div className='SidebarBox' style={sidebarBoxStyle}>
        {props.children}
      </div>
  )
}

function SectorInfo() {
  return (
    <div className='SectorInfo'>
        <p>testFunction: </p>
        <ContractData
          contract='Game'
          method='testFunction'
          methodArgs={[]}
        />
    </div>
  )
}




export default SideBar;

// export default () => (
//   <div className='App'>
//     <p>
//       <strong>TEST FROM COMP</strong>
//       <ContractData
//         contract='Game'
//         method='testFunction'
//         methodArgs={[]}
//       />
//     </p>

//   </div>
// );
