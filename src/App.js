import React, { useState, useEffect } from 'react';
import { ApiRequest } from './api/apiRequest';
import {
  CircularProgress,
  IconButton,
  Grid,
  Box,
  Container,
  CardContent,
} from '@material-ui/core';
import ReplayIcon from '@material-ui/icons/Replay';
import { TopBar } from './components/topBar';
import { TableWrapper } from './components/table/table-grid';
import Switch from '@material-ui/core/Switch';
import { withStyles } from '@material-ui/core/styles';
// import { findAllByTestId } from '@testing-library/react';
// import {
//   ArgumentAxis,
//   ValueAxis,
//   Chart,
//   LineSeries,
// } from '@devexpress/dx-react-chart-material-ui';

export default function App() {
  const request = new ApiRequest('http://192.168.1.10');

  const [allData, setAllData] = useState();
  const [state, setState] = React.useState({
    oledControl: true,
    checkedB: true,
  });

  async function handleRequest() {
    let data = request.getAllData();
    let archive = request.getArchive();

    data = await data;
    archive = await archive;

    data.temperature.archive = archive.temperature;
    data.sound.archive = archive.sound;

    setAllData(data);
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

  const handleChange = (event) => {
    setState({ ...state, [event.target.name]: event.target.checked });

    const requestOptions = {
      method: 'POST',
      headers: { 'Content-Type': 'text/plain' },
      body: JSON.stringify({ showMin: event.target.checked }),
    };
    console.log(requestOptions.body);

    fetch('http://192.168.1.10/api/display', requestOptions);
  };

  if (!allData) {
    return (
      <CircularProgress
        style={{
          position: 'absolute',
          left: '50%',
          top: '50%',
        }}
        disableShrink
      />
    );
  }

  return (
    <div id="app">
      <TopBar />
      <Grid
        container
        justify="center"
        direction="column"
        style={{ paddingTop: '2.5em' }}
      >
        <TableWrapper data={allData} />

        <IconButton
          aria-label="delete"
          style={{ width: 'fit-content', margin: '1em auto' }}
          size="medium"
          onClick={() => handleRequest()}
        >
          <ReplayIcon />
        </IconButton>
      </Grid>
      <Grid
        container
        direction="column"
        justifyContent="center"
        alignItems="center"
      >
        <Grid item>Affichage sur le OLED</Grid>
        <Grid
          item
          justify="center"
          container
          direction="row"
          justifyContent="center"
          alignItems="center"
        >
          <Grid item>Minimum</Grid>
          <Grid item>
            <Switch
              checked={state.checkedA}
              onChange={handleChange}
              name="oledControl"
              inputProps={{ 'aria-label': 'secondary checkbox' }}
            />
          </Grid>
          <Grid item>Maximum</Grid>
        </Grid>
      </Grid>
    </div>
  );
}
