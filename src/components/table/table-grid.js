import React from 'react';
import { TableInfo } from './table-cell';
import { Grid, Container, CircularProgress } from '@material-ui/core/';

const TableItems = ({props}) => {

  if (!props.length) {
    return <CircularProgress disableShrink />;
  }

  return props.map((cell ,index) => (
      <Grid key={index} item xs={12} sm={6} >
        <TableInfo data={cell}/>
      </Grid>
  ))

};

export const TableWrapper = ({ data, ...props }) => {
  console.log(data);

  const arrayDataType = [];
 
  Object.keys(data).map((item) => {
    const resultItem = data[`${item}`];
    resultItem['name'] = item;
    return arrayDataType.push(resultItem);
  });

  return (
    <Container maxWidth="md">
      <Grid container spacing={3}>
        {!props ? (
          <CircularProgress disableShrink />
        ) : (
          <TableItems props={arrayDataType} />
        )}
      </Grid>
    </Container>
  );
};
