import React, { useState, useEffect } from 'react';
import { ApiRequest } from './api/apiRequest';
import {CircularProgress, IconButton, Grid, Box,
  Container,
  CardContent,} from '@material-ui/core';
import ReplayIcon from '@material-ui/icons/Replay';
import {TopBar} from './components/topBar';
import {TableWrapper} from './components/table/table-grid';
import Switch from '@material-ui/core/Switch';
import { withStyles } from '@material-ui/core/styles';



export default function App() {
  
  const request = new ApiRequest('http://192.168.1.10');

  const [allData, setAllData] = useState();

  async function handleRequest() {
    console.log('Call getNextData');
    setAllData(await request.getAllData());
  }

  useEffect(() => {
    handleRequest();
  }, []);

  useEffect(() => {
    const interval = setInterval(() => {
      handleRequest();
    }, 250);
    return () => clearInterval(interval);
  }, []);

  console.log(allData);

  const handleChange = (event) => {
    console.log(event.target.checked);

    const requestOptions = {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ showMin: event.target.checked })
    };
    fetch('http://192.168.1.10/cmd/printxhr', requestOptions);
  };

  const AntSwitch = withStyles((theme) => ({
    root: {
      width: 28,
      height: 16,
      padding: 0,
      display: 'flex',
    },
    switchBase: {
      padding: 2,
      color: theme.palette.grey[500],
      '&$checked': {
        transform: 'translateX(12px)',
        color: theme.palette.common.white,
        '& + $track': {
          opacity: 1,
          backgroundColor: theme.palette.primary.main,
          borderColor: theme.palette.primary.main,
        },
      },
    },
    thumb: {
      width: 12,
      height: 12,
      boxShadow: 'none',
    },
    track: {
      border: `1px solid ${theme.palette.grey[500]}`,
      borderRadius: 16 / 2,
      opacity: 1,
      backgroundColor: theme.palette.common.white,
    },
    checked: {},
  }))(Switch);

  if (!allData) {
    return <CircularProgress style={{position: 'absolute',   left: "50%",
    top: "50%"}} disableShrink />;
  }

  return (
    <div id="app">
      <TopBar />
      <Grid
        container
        justify="center"
        direction="column"
        style={{paddingTop: '2.5em'}}
      >

      <TableWrapper data={allData}/>

      <IconButton aria-label="delete" style={{ width:'fit-content', margin:'1em auto'}} size="medium" onClick={() => handleRequest()}>
        <ReplayIcon /> 
      </IconButton>

      <AntSwitch checked={false} onChange={handleChange} name="oledControl" />

      </Grid>
    </div>
  );
}
