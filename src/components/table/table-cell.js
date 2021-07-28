import React, { useState } from 'react';
import {Table,TableBody,
  TableCell,
  TableContainer,
  TableRow,
  Typography} from '@material-ui/core/';

import Paper from '@material-ui/core/Paper';

import i18n from '../../translation.json'

export const TableInfo = ({ data }) => {
  const [translationValue, setTranslationValue] = useState('fr');

  const title = i18n.Translation[`${data.name}`][`${translationValue}`];
  const unit = i18n.Units[`${data.name}`][`${translationValue}`];
  
  return (
    <TableContainer component={Paper}>
      <Typography style={{padding:'16px'}} variant="h4" gutterBottom>
        {title}
      </Typography>
      <Table size="small" aria-label="a dense table">
        <TableBody>
        <TableRow key={'current'}>
            <TableCell align="center" colSpan={2} style={{fontSize: "50px"}} >{data.current !== null ? `${data.current} ${unit}` : 'Aucune donnée'}</TableCell>
          </TableRow>
          <TableRow key={'max'}>
            <TableCell component="th" scope="row">
              Maximum
            </TableCell>
            <TableCell align="right">{data.max !== null ? `${data.max} ${unit}` : 'Aucune donnée'}</TableCell>
          </TableRow>
          <TableRow key={'min'}>
            <TableCell component="th" scope="row">
              Minimum
            </TableCell>
            <TableCell align="right">{data.min !== null  ? `${data.min} ${unit}` : 'Aucune donnée'}</TableCell>
          </TableRow>
          <TableRow key={'avg'}>
            <TableCell component="th" scope="row">
              Moyenne
            </TableCell>
            <TableCell align="right">{data.avg !== null ? `${data.avg} ${unit}` : 'Aucune donnée'}</TableCell>
          </TableRow>
          <TableRow key={'archive'}>
            <TableCell component="th" scope="row">
              Dernières valeurs
            </TableCell>
            <TableCell align="right">{data.archive.slice(0,5).join(` ${unit}, `) + ` ${unit}`}</TableCell>
          </TableRow>
        </TableBody>
      </Table>
    </TableContainer>
  );
};
