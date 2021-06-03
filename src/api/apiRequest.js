export class ApiRequest {
    constructor(linkServer) {
        this.linkServer = linkServer;
        this.tempMax = 0;
        this.tempMin = 0;
        this.soundMax = 0;
        this.soundMin = 0;
        this.soundAvg = 0;
        this.allData = {};
    }
    
    async getAllData(){
        let res;

       await fetch(this.linkServer + "/api/full", {
            "method": "GET"
        })
			.then(response => response.json())
            .then(data => {
                res = data;
            })
            .catch(err => {
				console.log(err);
            });
            return res;
    }

    getTempMax() {
		console.log("Call getTempMax");
		console.log("TempMax Debut : " + this.tempMax);
        fetch(this.linkServer + "/api/temperature/max", {
            "method": "GET"
        })
			.then(response => response.json())
            .then(data => {
                this.tempMax = data["value"];
				console.log("TempMax Current : " + this.tempMax)
            })
            .catch(err => {
				console.log(err);
            });
        console.log("TempMax fin : " + (this.tempMax));
        return this.tempMax ?? 0;
    }

    getTempMin() {
		console.log("Call getTempMax");
        console.log("TempMin Debut : " + this.tempMin);
        fetch(this.linkServer + "/api/temperature/min", {
            "method": "GET"
        })
			.then(response => response.json())
            .then(data => {
                this.tempMin = data["value"];
				console.log("TempMin Current : " + this.tempMin)
            })
            .catch(err => {
				console.log(err);
            });
        console.log("TempMin fin : " + this.tempMin);
        return this.tempMin ?? 0;
    }

    getTempMoy() {
        fetch(this.linkServer + "/api/temperature/avg", {
            "method": "GET"
        })
			.then(response => response.json())
            .then(data => {
                this.tempAvg = data["value"];
            })
            .catch(err => {
				console.log(err);
            });
        return this.tempAvg ?? 0;
    }

    getSoundMax() {
        fetch(this.linkServer + "/api/sound/max", {
            "method": "GET"
        })
			.then(response => response.json())
            .then(data => {
                this.soundMax = data["value"];
            })
            .catch(err => {
				console.log(err);
            });
        return this.soundAvg ?? 0;
    }

    getSoundMin() {
        fetch(this.linkServer + "/api/sound/min", {
            "method": "GET"
        })
			.then(response => response.json())
            .then(data => {
                this.soundMax = data["value"];
            })
            .catch(err => {
				console.log(err);
            });
        return this.soundMax ?? 0;
    }

    getSoundMoy() {
        fetch(this.linkServer + "/api/sound/avg", {
            "method": "GET"
        })
			.then(response => response.json())
            .then(data => {
                this.soundAvg = data["value"];
            })
            .catch(err => {
				console.log(err);
            });
        return this.soundAvg ?? 0;
    }
};