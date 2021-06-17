import React, { useState, useEffect } from 'react';
import { ApiRequest } from './api/apiRequest';
import {CircularProgress, IconButton, Grid, Box,
  Container,
  CardContent,} from '@material-ui/core';
import ReplayIcon from '@material-ui/icons/Replay';
import {TopBar} from './components/topBar';
import {TableWrapper} from './components/table/table-grid';



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
    }, 1000);
    return () => clearInterval(interval);
  }, []);

  console.log(allData);

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

      </Grid>
    </div>
  );
}
