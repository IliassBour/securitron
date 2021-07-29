export class ApiRequest {
  constructor(linkServer) {
    this.linkServer = linkServer;
    this.tempMax = 0;
    this.tempMin = 0;
    this.tempAvg = 0;
    this.tempCurrent = 0;
    this.soundMax = 0;
    this.soundMin = 0;
    this.soundAvg = 0;
    this.soundCurrent = 0;
    this.allData = {};
  }

  async getAllData() {
    let res;

    await fetch(this.linkServer + '/api/full', {
      method: 'GET',
    })
      .then((response) => response.json())
      .then((data) => {
        res = data;
      })
      .catch((err) => {
        console.log(err);
      });
    return res;
  }

  async getArchive() {
    let res;

    await fetch(this.linkServer + '/api/archive/5', {
      method: 'GET',
    })
      .then((response) => response.json())
      .then((data) => {
        res = data;
      })
      .catch((err) => {
        console.log(err);
      });
    return res;
  }

  getTempMax() {
    console.log('Call getTempMax');
    console.log('TempMax Debut : ' + this.tempMax);
    fetch(this.linkServer + '/api/temperature/max', {
      method: 'GET',
    })
      .then((response) => response.json())
      .then((data) => {
        this.tempMax = data['value'];
        console.log('TempMax Current : ' + this.tempMax);
      })
      .catch((err) => {
        console.log(err);
      });
    console.log('TempMax fin : ' + this.tempMax);
    return this.tempMax ?? 0;
  }

  getTempMin() {
    console.log('Call getTempMax');
    console.log('TempMin Debut : ' + this.tempMin);
    fetch(this.linkServer + '/api/temperature/min', {
      method: 'GET',
    })
      .then((response) => response.json())
      .then((data) => {
        this.tempMin = data['value'];
        console.log('TempMin Current : ' + this.tempMin);
      })
      .catch((err) => {
        console.log(err);
      });
    console.log('TempMin fin : ' + this.tempMin);
    return this.tempMin ?? 0;
  }

  getTempMoy() {
    fetch(this.linkServer + '/api/temperature/avg', {
      method: 'GET',
    })
      .then((response) => response.json())
      .then((data) => {
        this.tempAvg = data['value'];
      })
      .catch((err) => {
        console.log(err);
      });
    return this.tempAvg ?? 0;
  }

  getTempCurrent() {
    console.log('Call getTempCurrent');
    console.log('TempCurrent Debut : ' + this.tempCurrent);
    fetch(this.linkServer + '/api/temperature/current', {
      method: 'GET',
    })
      .then((response) => response.json())
      .then((data) => {
        this.tempCurrent = data['value'];
        console.log('TempCurrent Current : ' + this.tempCurrent);
      })
      .catch((err) => {
        console.log(err);
      });
    console.log('TempCurrent fin : ' + this.tempCurrent);
    return this.tempCurrent ?? 0;
  }

  getSoundMax() {
    fetch(this.linkServer + '/api/sound/max', {
      method: 'GET',
    })
      .then((response) => response.json())
      .then((data) => {
        this.soundMax = data['value'];
      })
      .catch((err) => {
        console.log(err);
      });
    return this.soundAvg ?? 0;
  }

  getSoundMin() {
    fetch(this.linkServer + '/api/sound/min', {
      method: 'GET',
    })
      .then((response) => response.json())
      .then((data) => {
        this.soundMax = data['value'];
      })
      .catch((err) => {
        console.log(err);
      });
    return this.soundMax ?? 0;
  }

  getSoundMoy() {
    fetch(this.linkServer + '/api/sound/avg', {
      method: 'GET',
    })
      .then((response) => response.json())
      .then((data) => {
        this.soundAvg = data['value'];
      })
      .catch((err) => {
        console.log(err);
      });
    return this.soundAvg ?? 0;
  }

  getSoundCurrent() {
    fetch(this.linkServer + '/api/sound/current', {
      method: 'GET',
    })
      .then((response) => response.json())
      .then((data) => {
        this.soundCurrent = data['value'];
      })
      .catch((err) => {
        console.log(err);
      });
    return this.soundCurrent ?? 0;
  }
}
