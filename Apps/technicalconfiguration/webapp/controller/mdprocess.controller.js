sap.ui.define([
    "technicalConfiguration/controller/BaseController",
    "sap/ui/model/json/JSONModel",
    "sap/ui/model/Sorter",
    "sap/ui/model/Filter",
    "sap/m/Dialog",
    "sap/m/Button",
    "sap/m/MessageToast"
], function (BaseController, JSONModel, Sorter, Filter, Dialog, Button, MessageToast) {
    "use strict";

    return BaseController.extend("technicalConfiguration.controller.mdprocess", {

        /**
         * Se llama a la inicialización de la Vista
         */
        onInit: function () {
            //ruta para la vista principal
            this.getOwnerComponent().getRouter().getRoute("mdprocess").attachPatternMatched(this._onRouteMatched, this);
            //ruta para la vista de detalles de un registro
            this.getOwnerComponent().getRouter().getRoute("mdprocess_Record").attachPatternMatched(this._onRecordMatched, this);
            //ruta para la vista de creación de un registro
            this.getOwnerComponent().getRouter().getRoute("mdprocess_Create").attachPatternMatched(this._onCreateMatched, this);
        },

        /**
         * Coincidencia de ruta para acceder a la vista principal
         * @param  {Event} oEvent Evento que llamó esta función
         */
        _onRouteMatched: function (oEvent) {
            /**
             * @type {Controller} that         Referencia a este controlador
             * @type {JSONModel} OS            Referencia al modelo "OS"
             * @type {JSONModel} MDPROCESS        Referencia al modelo "MDPROCESS"
             */

            var util = this.getView().getModel("util"),
                mdprocess = this.getView().getModel("MDPROCESS");

            //dependiendo del dispositivo, establece la propiedad "phone"
            this.getView().getModel("util").setProperty("/phone/",
                this.getOwnerComponent().getContentDensityClass() === "sapUiSizeCozy");

            //establece process como la entidad seleccionada
            util.setProperty("/selectedEntity/", "mdprocess");


            //obtiene los registros de MDPROCESS
            this.onRead(util, mdprocess);
        },
        /**
         * Obtiene todos los registros de MDPROCESS
         * @param  {JSONModel} util         Referencia al modelo "util"
         * @param  {JSONModel} MDPROCESS Referencia al modelo "MDPROCESS"
         */
        onRead: function (util, mdprocess) {
            /** @type {Object} settings opciones de la llamada a la función ajax */
            var util = this.getView().getModel("util");
            var serviceUrl = util.getProperty("/serviceUrl");
            var settings = {
                url: serviceUrl + "/process/AllProcessJ",
                method: "GET",
                success: function (res) {
                    util.setProperty("/busy/", false);
                    mdprocess.setProperty("/records/", res.data);
                },
                error: function (err) {
                    util.setProperty("/error/status", err.status);
                    util.setProperty("/error/statusText", err.statusText);
                }
            };

            util.setProperty("/busy/", true);
            //borra los registros OSPARTNERSHIP que estén almacenados actualmente
            mdprocess.setProperty("/records/", []);
            //realiza la llamada ajax
            $.ajax(settings);
        },
        /**
         * Coincidencia de ruta para acceder a la creación de un registro
         * @param  {Event} oEvent Evento que llamó esta función
         */
        _onCreateMatched: async function (oEvent) {
            var create = true;
            // await this.loadCalendars(create);
            await this.loadStages(create);
            await this.onBreedLoad("/breed/");

            this._resetRecordValues();
            this._editRecordValues(true, false);
            this._editRecordRequired(true);
        },

        /**
         * Funcion para encontrar los productos por raza y etapa
         * @param  {JSONModel}  breed_id 
         */
        loadProducts: function (create, breed_id) {
            var mdproduct = this.getView().getModel("MDPRODUCT"),
                mdprocess = this.getView().getModel("MDPROCESS"),
                stage_id = mdprocess.getProperty("/stage_id/value"),
                breed = mdprocess.getProperty("/breed_id/value");

            var util = this.getView().getModel("util");
            var serviceUrl = util.getProperty("/serviceUrl");
            var settings = {
                url: serviceUrl + "/product/findProductsByBreedAndStage",
                method: "POST",
                data: {
                    breed_id: breed,
                    stage_id: stage_id
                },
                success: function (res) {
                    mdproduct.setProperty("/records", res.data);

                },
                error: function (err) {
                    util.setProperty("/error/status", err.status);
                    util.setProperty("/error/statusText", err.statusText);
                }
            };
            //borra los registros MDPRODUCT que estén almacenados actualmente
            mdproduct.setProperty("/records/", []);
            //realiza la llamada ajax
            $.ajax(settings);

        },
        /**
         *   obtener todos las etapas
         */
        loadStages: function (create) {
            var mdstage = this.getView().getModel("MDSTAGE");
            var util = this.getView().getModel("util");
            var serviceUrl = util.getProperty("/serviceUrl");
            var settings = {
                url: serviceUrl + "/stage/",
                method: "GET",
                success: function (res) {
                    mdstage.setProperty("/records", res.data);
                },
                error: function (err) {
                    util.setProperty("/error/status", err.status);
                    util.setProperty("/error/statusText", err.statusText);
                }
            };
            //borra los registros MDSTAGE que estén almacenados actualmente
            mdstage.setProperty("/records/", []);
            //realiza la llamada ajax
            $.ajax(settings);
        },

        /**
         *   obtener todos las etapas descendiente
         */
        loadPredecessorReBuild: function (create, process_id = 0) {

            var mdprocess = this.getView().getModel("MDPROCESS");
            var aPredecessor = mdprocess.getProperty("/records").slice();
            var dPredecessor = false;
            var i = 0;
            let breed_id = mdprocess.getProperty("/breed_id/value");

            fetch("/process/findProcessPredecessors", {
                    method: "POST",
                    headers: {
                        "Content-type": "application/json"
                    },
                    body: JSON.stringify({
                        breed_id: breed_id,
                        process_id: process_id
                    })
                })
                .then(response => {
                    if (response.status !== 200) {
                        console.log("Looks like there was a problem. Status Code: " +
                            response.status);
                        return;
                    }
                    response.json().then((res) => {
                        if (res.data.length > 0) {
                            mdprocess.setProperty("/predecessor", res.data);
                        } else {
                            MessageToast.show("No existen procesos predecesores asociados a la raza seleccionada");
                        }
                    });
                })
                .catch(err => console.log);
        },

        /**
         * Resetea todos los valores existentes en el formulario del registro
         */
        _resetRecordValues: function () {
            /**
             * @type {JSONModel} MDPROCESS Referencia al modelo "MDPROCESS"
             */
            var mdprocess = this.getView().getModel("MDPROCESS");

            mdprocess.setProperty("/name/editable", true);
            mdprocess.setProperty("/name/value", "");
            mdprocess.setProperty("/name/state", "None");
            mdprocess.setProperty("/name/stateText", "");
            mdprocess.setProperty("/name/ok", false); //

            mdprocess.setProperty("/process_order/value", "");
            mdprocess.setProperty("/process_order/state", "None");
            mdprocess.setProperty("/process_order/stateText", "");
            mdprocess.setProperty("/process_order/ok", false); //

            mdprocess.setProperty("/capacity/value", "");
            mdprocess.setProperty("/capacity/state", "None");
            mdprocess.setProperty("/capacity/stateText", "");
            mdprocess.setProperty("/capacity/ok", false); //

            mdprocess.setProperty("/historical_decrease/value", "");
            mdprocess.setProperty("/historical_decrease/state", "None");
            mdprocess.setProperty("/historical_decrease/stateText", "");
            mdprocess.setProperty("/historical_decrease/ok", false); //

            mdprocess.setProperty("/theoretical_decrease/value", "");
            mdprocess.setProperty("/theoretical_decrease/state", "None");
            mdprocess.setProperty("/theoretical_decrease/stateText", "");
            mdprocess.setProperty("/theoretical_decrease/ok", false); //

            mdprocess.setProperty("/historical_weight/value", "");
            mdprocess.setProperty("/historical_weight/state", "None");
            mdprocess.setProperty("/historical_weight/stateText", "");
            mdprocess.setProperty("/historical_weight/ok", false); //

            mdprocess.setProperty("/theoretical_weight/value", "");
            mdprocess.setProperty("/theoretical_weight/state", "None");
            mdprocess.setProperty("/theoretical_weight/stateText", "");
            mdprocess.setProperty("/theoretical_weight/ok", false); //

            mdprocess.setProperty("/historical_duration/value", "");
            mdprocess.setProperty("/historical_duration/state", "None");
            mdprocess.setProperty("/historical_duration/stateText", "");
            mdprocess.setProperty("/historical_duration/ok", false); //

            mdprocess.setProperty("/theoretical_duration/value", "");
            mdprocess.setProperty("/theoretical_duration/state", "None");
            mdprocess.setProperty("/theoretical_duration/stateText", "");
            mdprocess.setProperty("/theoretical_duration/ok", false); //

            mdprocess.setProperty("/breed_id/value", null);
            mdprocess.setProperty("/breed_id/state", "None");
            mdprocess.setProperty("/breed_id/stateText", "");

            mdprocess.setProperty("/stage_id/value", null);
            mdprocess.setProperty("/stage_id/state", "None");
            mdprocess.setProperty("/stage_id/stateText", "");
            mdprocess.setProperty("/stage_id/editable", false);

            mdprocess.setProperty("/product_id/value", null);
            mdprocess.setProperty("/product_id/state", "None");
            mdprocess.setProperty("/product_id/stateText", "");
            mdprocess.setProperty("/product_id/editable", false);
            this.getModel("MDPRODUCT").setProperty("/records", []);

            mdprocess.setProperty("/predecessor_id/value", "0");
            mdprocess.setProperty("/predecessor_id/state", "None");
            mdprocess.setProperty("/predecessor_id/stateText", "");
            mdprocess.setProperty("/predecessor", []);
            mdprocess.setProperty("/predecessor_id/editable", false);

            mdprocess.setProperty("/calendar_id/value", "");
            mdprocess.setProperty("/calendar_id/state", "None");
            mdprocess.setProperty("/calendar_id/stateText", "");
            mdprocess.setProperty("/calendar_id/editable", false);

            mdprocess.setProperty("/ispredecessor/value", false);
        },
        /**
         * Habilita/deshabilita la edición de los datos de un registro MDPROCESS
         * @param  {Boolean} edit "true" si habilita la edición, "false" si la deshabilita
         */
        _editRecordValues: function (edit, isEdit, update = false) {
            console.log(edit)
            var mdprocess = this.getView().getModel("MDPROCESS");
            mdprocess.setProperty("/process_order/editable", edit);
            mdprocess.setProperty("/product_id/editable", edit);
            mdprocess.setProperty("/stage_id/editable", edit);
            mdprocess.setProperty("/historical_decrease/editable", edit);
            mdprocess.setProperty("/theoretical_decrease/editable", edit);
            mdprocess.setProperty("/historical_weight/editable", edit);
            mdprocess.setProperty("/theoretical_weight/editable", edit);
            mdprocess.setProperty("/historical_duration/editable", edit);
            mdprocess.setProperty("/theoretical_duration/editable", edit);
            mdprocess.setProperty("/breed_id/editable", edit);
            mdprocess.setProperty("/calendar_id/editable", edit);
            mdprocess.setProperty("/visible/editable", edit);
            mdprocess.setProperty("/biological_active/editable", edit);
            mdprocess.setProperty("/sync_considered/editable", edit);
            mdprocess.setProperty("/name/editable", edit);
            mdprocess.setProperty("/capacity/editable", edit);
            mdprocess.setProperty("/product_id/editable", update);
            mdprocess.setProperty("/ispredecessor/editable", edit);

            if ((isEdit && (mdprocess.getProperty("/ispredecessor/value") == true))) {
                mdprocess.setProperty("/predecessor_id/editable", true);
            } else {
                mdprocess.setProperty("/predecessor_id/editable", false);
            }
        },
        /**
         * Se define un campo como obligatorio o no, de un registro MDPROCESS
         * @param  {Boolean} edit "true" si es campo obligatorio, "false" si no es obligatorio
         */
        _editRecordRequired: function (edit) {
            var mdprocess = this.getView().getModel("MDPROCESS");
            mdprocess.setProperty("/process_order/required", edit);
            mdprocess.setProperty("/historical_decrease/required", edit);
            mdprocess.setProperty("/theoretical_decrease/required", edit);
            mdprocess.setProperty("/historical_weight/required", edit);
            mdprocess.setProperty("/theoretical_weight/required", edit);
            mdprocess.setProperty("/historical_duration/required", edit);
            mdprocess.setProperty("/theoretical_duration/required", edit);
            mdprocess.setProperty("/visible/required", edit);
            mdprocess.setProperty("/active/required", edit);
            mdprocess.setProperty("/name/required", edit);
            mdprocess.setProperty("/capacity/required", edit);
            mdprocess.setProperty("/breed_id/required", edit);
            mdprocess.setProperty("/stage_id/required", edit);
            mdprocess.setProperty("/product_id/required", edit);
            mdprocess.setProperty("/calendar_id/required", edit);

        },

        /**
         * Reinicio los buscadores
         */
        resetSearch: function () {
            this.getView().byId("pprocessSearchField").setValue("");
            this.onProcessSearch();
        },

        /**
         * Navega a la vista para crear un nuevo registro
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onNewRecord: function (oEvent) {
            this.resetStatus();
            this.resetSearch();
            this.getRouter().navTo("mdprocess_Create", {}, false /*create history*/ );
        },
        /**
         * Cancela la creación de un registro MDPROCESS, y regresa a la vista principal
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onCancelCreate: function (oEvent) {
            this._resetRecordValues();
            this.onNavBack(oEvent);
        },
        /**
         * Regresa a la vista principal de la entidad seleccionada actualmente
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onNavBack: function (oEvent) {
            /** @type {JSONModel} OS Referencia al modelo "OS" */
            var util = this.getView().getModel("util");

            this.getRouter().navTo(util.getProperty("/selectedEntity"), {}, false /*create history*/ );
        },
        /**
         * Solicita al servicio correspondiente crear un registro process
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onCreate: function (oEvent) {
            //Si el registro que se desea crear es válido
            if (this._validRecord()) {
                /**
                 * @type {JSONModel} MDPROCESS   Referencia al modelo "MDPROCESS"
                 * @type {JSONModel} util    Referencia al modelo "util"
                 * @type {Controller} that    Referencia a este controlador
                 * @type {Object} json        Objeto a enviar en la solicitud
                 * @type {Object} settings    Opciones de la llamada a la función ajax
                 */
                var that = this;
                var util = this.getView().getModel("util");
                var mdparameter = this.getView().getModel("MDPARAMETER");
                var mdprocess = this.getView().getModel("MDPROCESS");
                var mdproduct = this.getView().getModel("MDPRODUCT");
                var mdstage = this.getView().getModel("MDSTAGE");
                var txcalendar = this.getView().getModel("TXCALENDAR");

                var predecessor_id = 0;

                if (mdprocess.getProperty("/ispredecessor/value") == true) {
                    predecessor_id = mdprocess.getProperty("/predecessor_id/value");
                }
                var serviceUrl = util.getProperty("/serviceUrl");

                $.ajax({
                    type: "POST",
                    contentType: "application/json",
                    data: JSON.stringify({
                        "process_order": mdprocess.getProperty("/process_order/value"),
                        "product_id": mdprocess.getProperty("/product_id/value"),
                        "stage_id": mdprocess.getProperty("/stage_id/value"),
                        "breed_id": mdprocess.getProperty("/breed_id/value"),
                        "name": mdprocess.getProperty("/name/value"),
                        "predecessor_id": predecessor_id === 0 ? null : predecessor_id,
                        "capacity": mdprocess.getProperty("/capacity/value"),
                        "historical_decrease": mdprocess.getProperty("/historical_decrease/value"),
                        "historical_weight": mdprocess.getProperty("/historical_weight/value"),
                        "historical_duration": mdprocess.getProperty("/historical_duration/value"),
                        "gender": "Masculino",
                        "fattening_goal": 0,
                        "type_posture": "Joven",
                        "process_class_id": 2,
                        "biological_active": mdprocess.getProperty("/biological_active/value") == 1 ? true : false,
                        "sync_considered": mdprocess.getProperty("/sync_considered/value") == 1 ? true : false,
                        "visible": true
                    }),
                    url: serviceUrl + "/process/",
                    dataType: "json",
                    async: true,
                    success: function (data) {
                        util.setProperty("/busy/", false);
                        that._resetRecordValues();
                        that.onToast(that.getI18n().getText("OS.recordCreated"));
                        that.getRouter().navTo("mdprocess", {}, true /*no history*/ );

                    },
                    error: function (error) {
                        that.onToast("Error de comunicación");
                        console.log("Read failed ", error.responseText);
                    }
                });

            }
        },

        /**
         * Este evento se activa cuando se cambia el valor en el campo de selección de Producto en el formulario.
         * @param  {Event} oEvent Evento que llamó esta función
         */
        updateProductModel: function (oEvent) {
            var mdprocess = this.getView().getModel("MDPROCESS");
            mdprocess.setProperty("/product_id/state", "None");
            mdprocess.setProperty("/product_id/stateText", "");
            mdprocess.setProperty("/product_id/value", this.getView().byId("process_nameProduct_model").getSelectedKey());
        },

        /**
         * Este evento se activa cuando se cambia el valor en el campo de selección de Etapa en el formulario.
         */
        updateStageModel: function () {
            var mdprocess = this.getView().getModel("MDPROCESS");
            mdprocess.setProperty("/stage_id/value", this.getView().byId("process_stage_model").getSelectedKey());
            let selectedText = this.getView().byId("process_stage_model").getSelectedItem().mProperties.text;
            let sServerName = (selectedText === "Cría y Levante") || selectedText === "Reproductoras" ? "/breed/findAllBreedWP" : "/breed/";
            this.loadProducts(true)
            this.onBreedLoad(sServerName);
            mdprocess.setProperty("/product_id/editable", true);
            mdprocess.setProperty("/stage_id/state", "None");
            mdprocess.setProperty("/stage_id/stateText", "");

        },

        /**
         * carga todas las razas
         * @param {string} serverName ruta
         */
        onBreedLoad: function (serverName) {

            var mdbreed = this.getView().getModel("MDBREED");

            mdbreed.setProperty("/records", []);

            let isRecords = new Promise((resolve, reject) => {
                fetch(serverName).then(
                    function (response) {
                        if (response.status !== 200) {
                            console.log("Looks like there was a problem. status code: " + response.status);
                            return;
                        }
                        response.json().then(function (data) {
                            resolve(data);
                        });
                    }
                ).catch(function (err) {
                    console.error("Fetch error:", err);
                });
            });

            isRecords.then((res) => {

                if (res.data.length > 0) {
                    mdbreed.setProperty("/records", res.data);
                }
            });
        },

        /**
         * Este evento se activa cuando se cambia el valor en el campo de selección de Predecesor en el formulario.
         */
        updatePredecessorModel: function () {
            var mdprocess = this.getView().getModel("MDPROCESS");
            mdprocess.setProperty("/predecessor_id/value", this.getView().byId("process_predecessor_model").getSelectedKey());
            mdprocess.setProperty("/predecessor_id/state", "None");
            mdprocess.setProperty("/predecessor_id/stateText", "");
        },

        /**
         * Este evento se activa cuando se cambia el valor en el campo de selección de Raza en el formulario.
         */
        updateBreedModel: function () {
            var mdprocess = this.getView().getModel("MDPROCESS");
            let breed_id = this.getView().byId("process_breed_model").getSelectedKey();
            var process_id = mdprocess.getProperty("/process_id/value");
            mdprocess.setProperty("/breed_id/value", breed_id);
            mdprocess.setProperty("/breed_id/state", "None");
            mdprocess.setProperty("/breed_id/stateText", "");
            mdprocess.setProperty("/stage_id/editable", true);
            this.loadPredecessorReBuild(true, process_id)

        },
        /**
         * Valida la correctitud de los datos existentes en el formulario del registro
         * @return {Boolean} Devuelve "true" si los datos son correctos, y "false" si son incorrectos
         */
        _validRecord: function () {
            /**
             * @type {JSONModel} MDPROCESS Referencia al modelo "MDPROCESS"
             * @type {Boolean} flag "true" si los datos son válidos, "false" si no lo son
             */
            var mdprocess = this.getView().getModel("MDPROCESS"),
                flag = true,
                that = this,
                Without_SoL = /^\d+$/,
                Without_Num = /^[a-zA-Zñáéíóú| ]*$/,
                onlyDecimals = /^[0-9]*\.?[0-9]*$/;


            if (mdprocess.getProperty("/name/value") === "") {
                flag = false;
                mdprocess.setProperty("/name/state", "Error");
                mdprocess.setProperty("/name/stateText", this.getI18n().getText("enter.FIELD"));
            } else if (mdprocess.getProperty("/name/state") === "Error") {
                flag = false;
            } else {
                mdprocess.setProperty("/name/state", "None");
                mdprocess.setProperty("/name/stateText", "");
            }


            if (mdprocess.getProperty("/process_order/state") === "Error") {
                flag = false;
            } else {
                if (mdprocess.getProperty("/process_order/value") === "") {
                    flag = false;
                    mdprocess.setProperty("/process_order/state", "Error");
                    mdprocess.setProperty("/process_order/stateText", this.getI18n().getText("enter.FIELD"));
                } else if (mdprocess.getProperty("/process_order/state") === "Error") {
                    flag = false;
                } else {
                    mdprocess.setProperty("/process_order/state", "None");
                    mdprocess.setProperty("/process_order/stateText", "");
                }
            }

            if (parseInt(mdprocess.getProperty("/capacity/value")) === 0) {
                flag = false;
                mdprocess.setProperty("/capacity/state", "Error");
                mdprocess.setProperty("/capacity/stateText", "Debe ser mayor a cero (0)");
            } else {
                if (mdprocess.getProperty("/capacity/value") === "") {
                    flag = false;
                    mdprocess.setProperty("/capacity/state", "Error");
                    mdprocess.setProperty("/capacity/stateText", this.getI18n().getText("enter.FIELD"));
                } else if (!Without_SoL.test(mdprocess.getProperty("/capacity/value"))) {
                    flag = false;
                    mdprocess.setProperty("/capacity/state", "Error");
                    mdprocess.setProperty("/capacity/stateText", this.getI18n().getText("enter.FIELD.WS"));
                } else {
                    mdprocess.setProperty("/capacity/state", "None");
                    mdprocess.setProperty("/capacity/stateText", "");
                }
            }

            if (mdprocess.getProperty("/historical_duration/value") === "") {
                flag = false;
                mdprocess.setProperty("/historical_duration/state", "Error");
                mdprocess.setProperty("/historical_duration/stateText", this.getI18n().getText("enter.FIELD"));
            } else if (!Without_SoL.test(mdprocess.getProperty("/historical_duration/value"))) {
                flag = false;
                mdprocess.setProperty("/historical_duration/state", "Error");
                mdprocess.setProperty("/historical_duration/stateText", this.getI18n().getText("enter.FIELD.WS"));
            } else {
                mdprocess.setProperty("/historical_duration/state", "None");
                mdprocess.setProperty("/historical_duration/stateText", "");
            }

            if (mdprocess.getProperty("/historical_decrease/value") === "") {
                flag = false;
                mdprocess.setProperty("/historical_decrease/state", "Error");
                mdprocess.setProperty("/historical_decrease/stateText", this.getI18n().getText("enter.FIELD"));
            } else if (!onlyDecimals.test(mdprocess.getProperty("/historical_decrease/value"))) {
                flag = false;
                mdprocess.setProperty("/historical_decrease/state", "Error");
                mdprocess.setProperty("/historical_decrease/stateText", this.getI18n().getText("enter.FIELD.onlyD"));
            } else {
                mdprocess.setProperty("/historical_decrease/state", "None");
                mdprocess.setProperty("/historical_decrease/stateText", "");
            }

            if (parseFloat(mdprocess.getProperty("/historical_weight/value")) === 0) {
                flag = false;
                mdprocess.setProperty("/historical_weight/state", "Error");
                mdprocess.setProperty("/historical_weight/stateText", "Debe ser mayor a cero (0)");
            } else {
                if (mdprocess.getProperty("/historical_weight/value") === "") {
                    flag = false;
                    mdprocess.setProperty("/historical_weight/state", "Error");
                    mdprocess.setProperty("/historical_weight/stateText", this.getI18n().getText("enter.FIELD"));
                } else {
                    mdprocess.setProperty("/historical_weight/state", "None");
                    mdprocess.setProperty("/historical_weight/stateText", "");
                }
            }

            if (mdprocess.getProperty("/breed_id/value") === null) {
                flag = false;
                mdprocess.setProperty("/breed_id/state", "Error");
                mdprocess.setProperty("/breed_id/stateText", "Debe seleccionar una raza");
            } else {
                mdprocess.setProperty("/breed_id/state", "None");
                mdprocess.setProperty("/breed_id/stateText", "");
            }

            // if (mdprocess.getProperty("/calendar_id/value") === "") {
            //     flag = false;
            //     mdprocess.setProperty("/calendar_id/state", "Error");
            //     mdprocess.setProperty("/calendar_id/stateText", "Debe indicar un calendario");
            // }else {
            //     mdprocess.setProperty("/calendar_id/state", "None");
            //     mdprocess.setProperty("/calendar_id/stateText", "");
            // }
            if (mdprocess.getProperty("/product_id/value") === null) {
                flag = false;
                mdprocess.setProperty("/product_id/state", "Error");
                mdprocess.setProperty("/product_id/stateText", "Debe indicar un producto");
            } else {
                mdprocess.setProperty("/product_id/state", "None");
                mdprocess.setProperty("/product_id/stateText", "");
            }

            if (mdprocess.getProperty("/stage_id/value") === null) {
                flag = false;
                mdprocess.setProperty("/stage_id/state", "Error");
                mdprocess.setProperty("/stage_id/stateText", "Debe indicar una etapa");
            } else {
                mdprocess.setProperty("/stage_id/state", "None");
                mdprocess.setProperty("/stage_id/stateText", "");
            }

            if (mdprocess.getProperty("/ispredecessor/value") === true) {
                if (mdprocess.getProperty("/predecessor_id/value") === "0") {
                    flag = false;
                    mdprocess.setProperty("/predecessor_id/state", "Error");
                    mdprocess.setProperty("/predecessor_id/stateText", "Debe indicar un proceso predecesor");
                } else {
                    mdprocess.setProperty("/predecessor_id/state", "None");
                    mdprocess.setProperty("/predecessor_id/stateText", "");
                }
            } else {
                mdprocess.setProperty("/predecessor_id/state", "None");
                mdprocess.setProperty("/predecessor_id/stateText", "");
            }


            return flag;
        },
        /**
         * Visualiza los detalles de un registro MDPROCESS
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onViewProcessRecord: function (oEvent) {
            var mdprocess = this.getView().getModel("MDPROCESS");
            var create = false;

            this.resetStatus();

            mdprocess.setProperty("/save/", false);
            mdprocess.setProperty("/cancel/", false);
            mdprocess.setProperty("/selectedRecordPath/", oEvent.getSource().getBindingContext("MDPROCESS"));
            mdprocess.setProperty("/process_id/value", oEvent.getSource().getBindingContext("MDPROCESS").getObject().process_id);
            mdprocess.setProperty("/process_order/value", oEvent.getSource().getBindingContext("MDPROCESS").getObject().process_order);
            mdprocess.setProperty("/product_id/value", oEvent.getSource().getBindingContext("MDPROCESS").getObject().product_id);
            mdprocess.setProperty("/stage_id/value", oEvent.getSource().getBindingContext("MDPROCESS").getObject().stage_id);
            mdprocess.setProperty("/historical_decrease/value", oEvent.getSource().getBindingContext("MDPROCESS").getObject().historical_decrease);
            mdprocess.setProperty("/theoretical_decrease/value", oEvent.getSource().getBindingContext("MDPROCESS").getObject().theoretical_decrease);
            mdprocess.setProperty("/historical_weight/value", oEvent.getSource().getBindingContext("MDPROCESS").getObject().historical_weight);
            mdprocess.setProperty("/theoretical_weight/value", oEvent.getSource().getBindingContext("MDPROCESS").getObject().theoretical_weight);
            mdprocess.setProperty("/historical_duration/value", oEvent.getSource().getBindingContext("MDPROCESS").getObject().historical_duration);
            mdprocess.setProperty("/theoretical_duration/value", oEvent.getSource().getBindingContext("MDPROCESS").getObject().theoretical_duration);
            mdprocess.setProperty("/breed_id/value", oEvent.getSource().getBindingContext("MDPROCESS").getObject().breed_id);
            mdprocess.setProperty("/calendar_id/value", oEvent.getSource().getBindingContext("MDPROCESS").getObject().calendar_id);
            mdprocess.setProperty("/visible/value", true);
            mdprocess.setProperty("/name/value", oEvent.getSource().getBindingContext("MDPROCESS").getObject().name);
            mdprocess.setProperty("/name/excepcion", oEvent.getSource().getBindingContext("MDPROCESS").getObject().name);
            mdprocess.setProperty("/predecessor_id/value", oEvent.getSource().getBindingContext("MDPROCESS").getObject().predecessor_id);
            mdprocess.setProperty("/capacity/value", oEvent.getSource().getBindingContext("MDPROCESS").getObject().capacity);



            let number = oEvent.getSource().getBindingContext("MDPROCESS").getObject().ispredecessor
            if (number === 1) {
                number = true
            } else {
                number = false
            }
            mdprocess.setProperty("/ispredecessor/value", number);

            mdprocess.setProperty("/biological_active/value", oEvent.getSource().getBindingContext("MDPROCESS").getObject().biological_active);
            mdprocess.setProperty("/sync_considered/value", oEvent.getSource().getBindingContext("MDPROCESS").getObject().sync_considered);

            this.loadStages(create);
            // this.loadCalendars(create);
            this.onBreedLoad("/breed/");
            this.loadProducts(create, oEvent.getSource().getBindingContext("MDPROCESS").getObject().breed_id);
            this.loadPredecessorReBuild(create, oEvent.getSource().getBindingContext("MDPROCESS").getObject().process_id)

            this.resetSearch();

            this.getRouter().navTo("mdprocess_Record", {}, false /*create history*/ );
        },
        /**
         * Coincidencia de ruta para acceder a los detalles de un registro
         * @param  {Event} oEvent Evento que llamó esta función
         */
        _onRecordMatched: function (oEvent) {
            this._viewOptions();
        },
        /**
         * Cambia las opciones de visualización disponibles en la vista de detalles de un registro
         */
        _viewOptions: function () {
            var mdprocess = this.getView().getModel("MDPROCESS");
            mdprocess.setProperty("/cancel/", false);
            mdprocess.setProperty("/modify/", true);
            mdprocess.setProperty("/delete/", true);
            mdprocess.setProperty("/save/", false);
            this._editRecordValues(false, false);
            this._editRecordRequired(false);

        },
        /**
         * Ajusta la vista para editar los datos de un registro
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onEdit: function (oEvent) {

            var mdprocess = this.getView().getModel("MDPROCESS");
            mdprocess.setProperty("/save/", true);
            mdprocess.setProperty("/cancel/", true);
            mdprocess.setProperty("/modify/", false);
            mdprocess.setProperty("/delete/", false);
            // Copio registro
            let copy = {
                process_id: mdprocess.getProperty("/process_id/value"),
                process_order: mdprocess.getProperty("/process_order/value"),
                product_id: mdprocess.getProperty("/product_id/value"),
                stage_id: mdprocess.getProperty("/stage_id/value"),
                historical_decrease: mdprocess.getProperty("/historical_decrease/value"),
                theoretical_decrease: mdprocess.getProperty("/theoretical_decrease/value"),
                historical_weight: mdprocess.getProperty("/historical_weight/value"),
                theoretical_weight: mdprocess.getProperty("/theoretical_weight/value"),
                historical_duration: mdprocess.getProperty("/historical_duration/value"),
                theoretical_duration: mdprocess.getProperty("/theoretical_duration/value"),
                breed_id: mdprocess.getProperty("/breed_id/value"),
                calendar_id: mdprocess.getProperty("/calendar_id/value"),
                visible: mdprocess.getProperty("/visible/value"),
                name: mdprocess.getProperty("/name/value"),
                predecessor_id: mdprocess.getProperty("/predecessor_id/value"),
                capacity: mdprocess.getProperty("/capacity/value"),
                ispredecessor: mdprocess.getProperty("/ispredecessor/value"),
                biological_active: mdprocess.getProperty("/biological_active/value"),
                sync_considered: mdprocess.getProperty("/sync_considered/value")
            }
            mdprocess.setProperty("/copy", copy);
            this._editRecordRequired(true);
            /*
             * Envio que los datos deben ser editables y que estoy llamando a la funcion desde edit
             */
            this._editRecordValues(true, true, true);
        },

        /**
         * Cancela la edición de un registro MDPROCESS
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onCancelEdit: function (oEvent) {
            /** @type {JSONModel} MDPROCESS  Referencia al modelo MDPROCESS */
            let mdprocess = this.getView().getModel("MDPROCESS");

            this.resetStatus();

            let copy = mdprocess.getProperty("/copy")
            mdprocess.setProperty("/process_id/value", copy.process_id);
            mdprocess.setProperty("/process_order/value", copy.process_order);
            mdprocess.setProperty("/stage_id/value", copy.stage_id);
            mdprocess.setProperty("/historical_decrease/value", copy.historical_decrease);
            mdprocess.setProperty("/theoretical_decrease/value", copy.theoretical_decrease);
            mdprocess.setProperty("/historical_weight/value", copy.historical_weight);
            mdprocess.setProperty("/theoretical_weight/value", copy.theoretical_weight);
            mdprocess.setProperty("/historical_duration/value", copy.historical_duration);
            mdprocess.setProperty("/theoretical_duration/value", copy.theoretical_duration);
            mdprocess.setProperty("/breed_id/value", copy.breed_id);
            this.loadProducts(false, copy.breed_id);
            mdprocess.setProperty("/product_id/value", copy.product_id);
            mdprocess.setProperty("/calendar_id/value", copy.calendar_id);
            mdprocess.setProperty("/visible/value", copy.visible);
            mdprocess.setProperty("/name/value", copy.name);
            mdprocess.setProperty("/predecessor_id/value", copy.predecessor_id);
            mdprocess.setProperty("/capacity/value", copy.capacity);
            mdprocess.setProperty("/ispredecessor/value", copy.ispredecessor);
            mdprocess.setProperty("/biological_active/value", copy.biological_active);
            mdprocess.setProperty("/sync_considered/value", copy.sync_considered);

            mdprocess.setProperty("/saveEnabled", true);

            this.onView();
        },

        /**
         * Reinicia las propiedades del modelo "MDPROCESS"
         */
        resetStatus: function () {

            let mdprocess = this.getView().getModel("MDPROCESS");

            mdprocess.setProperty("/name/state", "None");
            mdprocess.setProperty("/name/stateText", "");
            mdprocess.setProperty("/process_order/state", "None");
            mdprocess.setProperty("/process_order/stateText", "");
            mdprocess.setProperty("/capacity/state", "None");
            mdprocess.setProperty("/capacity/stateText", "");
            mdprocess.setProperty("/breed_id/state", "None");
            mdprocess.setProperty("/breed_id/stateText", "");
            mdprocess.setProperty("/stage_id/state", "None");
            mdprocess.setProperty("/stage_id/stateText", "");
            mdprocess.setProperty("/product_id/state", "None");
            mdprocess.setProperty("/product_id/stateText", "");
            mdprocess.setProperty("/calendar_id/state", "None");
            mdprocess.setProperty("/calendar_id/stateText", "");
            mdprocess.setProperty("/ispredecessor/value", false);

            mdprocess.setProperty("/predecessor_id/state", "None");
            mdprocess.setProperty("/predecessor_id/stateText", "");
            mdprocess.setProperty("/biological_active/value", false);

            mdprocess.setProperty("/historical_decrease/state", "None");
            mdprocess.setProperty("/historical_decrease/stateText", "");
            mdprocess.setProperty("/theoretical_decrease/state", "None");
            mdprocess.setProperty("/theoretical_decrease/stateText", "");
            mdprocess.setProperty("/sync_considered/value", false);

            mdprocess.setProperty("/historical_weight/state", "None");
            mdprocess.setProperty("/historical_weight/stateText", "");
            mdprocess.setProperty("/theoretical_weight/state", "None");
            mdprocess.setProperty("/theoretical_weight/stateText", "");
            mdprocess.setProperty("/historical_duration/state", "None");
            mdprocess.setProperty("/historical_duration/stateText", "");
            mdprocess.setProperty("/theoretical_duration/state", "None");
            mdprocess.setProperty("/theoretical_duration/stateText", "");
            mdprocess.setProperty("/predecessor_id/state", "None");
            mdprocess.setProperty("/predecessor_id/stateText", "");
        },
        /**
         * Ajusta la vista para visualizar los datos de un registro
         */
        onView: function () {
            this._viewOptions();
        },
        /**
         * Solicita al servicio correspondiente actualizar un registro MDPROCESS
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onUpdate: function (oEvent) {
            /**
             * Si el registro que se quiere actualizar es válido y hubo algún cambio
             * con respecto a sus datos originales
             */
            if (this._validRecord() && this._recordChanged()) {
                /**
                 * @type {JSONModel} MDPROCESS   Referencia al modelo "MDPROCESS"
                 * @type {JSONModel} util         Referencia al modelo "util"
                 * @type {Controller} that         Referencia a este controlador
                 */
                var mdprocess = this.getView().getModel("MDPROCESS");
                var util = this.getView().getModel("util");
                var that = this;
                var predecessor_id = null;

                if (mdprocess.getProperty("/ispredecessor/value") == true) {
                    predecessor_id = mdprocess.getProperty("/predecessor_id/value");
                }
                var serviceUrl = util.getProperty("/serviceUrl");
                $.ajax({
                    type: "PUT",
                    contentType: "application/json",
                    data: JSON.stringify({
                        "process_order": mdprocess.getProperty("/process_order/value"),
                        "product_id": mdprocess.getProperty("/product_id/value"),
                        "stage_id": mdprocess.getProperty("/stage_id/value"),
                        "breed_id": mdprocess.getProperty("/breed_id/value"),
                        "calendar_id": mdprocess.getProperty("/calendar_id/value"),
                        "name": mdprocess.getProperty("/name/value"),
                        "predecessor_id": predecessor_id,
                        "capacity": mdprocess.getProperty("/capacity/value"),
                        "historical_decrease": mdprocess.getProperty("/historical_decrease/value"),
                        "theoretical_decrease": mdprocess.getProperty("/theoretical_decrease/value"),
                        "historical_weight": mdprocess.getProperty("/historical_weight/value"),
                        "theoretical_weight": mdprocess.getProperty("/theoretical_weight/value"),
                        "historical_duration": mdprocess.getProperty("/historical_duration/value"),
                        "theoretical_duration": mdprocess.getProperty("/theoretical_duration/value"),
                        "gender": "Masculino",
                        "fattening_goal": 0,
                        "type_posture": "Joven",
                        "process_class_id": 2,
                        "biological_active": mdprocess.getProperty("/biological_active/value") == 1 ? true : false,
                        "sync_considered": mdprocess.getProperty("/sync_considered/value") == 1 ? true : false,
                        "visible": true,
                        "process_id": mdprocess.getProperty("/process_id/value")
                    }),
                    url: serviceUrl + "/process/",
                    dataType: "json",
                    async: true,
                    success: function (data) {

                        util.setProperty("/busy/", false);
                        that._resetRecordValues();
                        that._viewOptions();
                        that.onToast(that.getI18n().getText("OS.recordUpdated"));
                        that.getRouter().navTo("mdprocess", {}, true /*no history*/ );

                    },
                    error: function (request, status, error) {
                        that.onToast("Error de comunicación");
                        console.log("Read failed");
                    }
                });
            }
        },
        /**
         * Verifica si el registro seleccionado tiene algún cambio con respecto a sus valores originales
         * @return {Boolean} Devuelve "true" el registro cambió, y "false" si no cambió
         */
        _recordChanged: function () {
            /**
             * @type {JSONModel} MDPROCESS     Referencia al modelo "MDPROCESS"
             * @type {Boolean} flag            "true" si el registro cambió, "false" si no cambió
             */
            var mdprocess = this.getView().getModel("MDPROCESS"),
                flag = false;

            if (mdprocess.getProperty("/name/value") !== mdprocess.getProperty(mdprocess.getProperty("/selectedRecordPath/") + "/name")) {
                flag = true;
            }

            if (mdprocess.getProperty("/process_order/value") !== mdprocess.getProperty(mdprocess.getProperty("/selectedRecordPath/") + "/process_order")) {
                flag = true;
            }

            if (mdprocess.getProperty("/calendar_id/value") !== mdprocess.getProperty(mdprocess.getProperty("/selectedRecordPath/") + "/calendar_id")) {
                flag = true;
            }


            if (mdprocess.getProperty("/capacity/value") !== mdprocess.getProperty(mdprocess.getProperty("/selectedRecordPath/") + "/capacity")) {
                flag = true;
            }

            if (mdprocess.getProperty("/historical_decrease/value") !== mdprocess.getProperty(mdprocess.getProperty("/selectedRecordPath/") + "/historical_decrease")) {
                flag = true;
            }

            if (mdprocess.getProperty("/theoretical_decrease/value") !== mdprocess.getProperty(mdprocess.getProperty("/selectedRecordPath/") + "/theoretical_decrease")) {
                flag = true;
            }

            if (mdprocess.getProperty("/historical_weight/value") !== mdprocess.getProperty(mdprocess.getProperty("/selectedRecordPath/") + "/historical_weight")) {
                flag = true;
            }

            if (mdprocess.getProperty("/theoretical_weight/value") !== mdprocess.getProperty(mdprocess.getProperty("/selectedRecordPath/") + "/theoretical_weight")) {
                flag = true;
            }

            if (mdprocess.getProperty("/historical_duration/value") !== mdprocess.getProperty(mdprocess.getProperty("/selectedRecordPath/") + "/historical_duration")) {
                flag = true;
            }

            if (mdprocess.getProperty("/theoretical_duration/value") !== mdprocess.getProperty(mdprocess.getProperty("/selectedRecordPath/") + "/theoretical_duration")) {
                flag = true;
            }

            if (mdprocess.getProperty("/product_id/value") !== mdprocess.getProperty(mdprocess.getProperty("/selectedRecordPath/") + "/product_id")) {
                flag = true;
            }

            if (mdprocess.getProperty("/stage_id/value") !== mdprocess.getProperty(mdprocess.getProperty("/selectedRecordPath/") + "/stage_id")) {
                flag = true;
            }

            if (mdprocess.getProperty("/predecessor_id/value") !== mdprocess.getProperty(mdprocess.getProperty("/selectedRecordPath/") + "/predecessor_id")) {
                flag = true;
            }

            if (mdprocess.getProperty("/visible/value") !== mdprocess.getProperty(mdprocess.getProperty("/selectedRecordPath/") + "/visible")) {
                flag = true;
            }

            if (mdprocess.getProperty("/ispredecessor/value") !== mdprocess.getProperty(mdprocess.getProperty("/selectedRecordPath/") + "/ispredecessor")) {
                flag = true;
            }

            if (mdprocess.getProperty("/biological_active/value") !== mdprocess.getProperty(mdprocess.getProperty("/selectedRecordPath/") + "/biological_active")) {
                flag = true;
            }
            if (mdprocess.getProperty("/sync_considered/value") !== mdprocess.getProperty(mdprocess.getProperty("/selectedRecordPath/") + "/sync_considered")) {
                flag = true;
            }

            if (!flag) this.onToast("No se detectaron cambios");

            return flag;
        },

        /**
         * Se activa cuando selecciona una razay muestra su informacion.
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onProcessSearch: function (oEvent) {
            let sQuery = this.getView().byId("pprocessSearchField").getValue().toString(),
                binding = this.getView().byId("processTable").getBinding("items");

            if (sQuery) {
                let name = new Filter("name", sap.ui.model.FilterOperator.Contains, sQuery);
                let product_name = new Filter("product_name", sap.ui.model.FilterOperator.Contains, sQuery);
                let stage_name = new Filter("stage_name", sap.ui.model.FilterOperator.Contains, sQuery);

                var oFilter = new sap.ui.model.Filter({
                    aFilters: [name, product_name, stage_name],
                    and: false
                });
            }

            binding.filter(oFilter);

        },

        /**
         * Levanta el Dialogo que muestra la confirmacion del Eliminar un registro y ejecuta la peticion de ser aceptado el borrado
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onConfirmDelete: async function (oEvent) {
            var oBundle = this.getView().getModel("i18n").getResourceBundle();
            var confirmation = oBundle.getText("confirmation");
            var that = this,
                util = this.getView().getModel("util"),
                mdprocess = that.getView().getModel("MDPROCESS"),
                process_id = mdprocess.getProperty("/process_id/value");

            let cond = await this.onVerifyIsUsed(process_id);

            if (cond) {
                var dialog = new Dialog({
                    title: "Información",
                    type: "Message",
                    state: "Warning",
                    content: new sap.m.Text({
                        text: "No se puede eliminar el proceso, porque está siendo utilizado."
                    }),
                    beginButton: new Button({
                        text: "OK",
                        press: function() {
                            dialog.close();
                        }
                    }),
                    afterClose: function() {
                        dialog.destroy();
                    }
                });
        
                dialog.open();
            } else {
                var dialog = new Dialog({
                    title: confirmation,
                    type: "Message",
                    content: new sap.m.Text({
                        text: "¿Desea eliminar este proceso?"
                    }),

                    beginButton: new Button({
                        text: "Si",
                        press: function () {
                            util.setProperty("/busy/", true);
                            var serviceUrl = util.getProperty("/serviceUrl");
                            $.ajax({
                                type: "DELETE",
                                contentType: "application/json",
                                data: JSON.stringify({
                                    "process_id": mdprocess.getProperty("/process_id/value")
                                }),
                                url: serviceUrl + "/process/",
                                dataType: "json",
                                async: true,
                                success: function (data) {

                                    util.setProperty("/busy/", false);
                                    that.getRouter().navTo("mdprocess", {}, true);
                                    dialog.close();

                                },
                                error: function (request, status, error) {
                                    that.onToast("Error de comunicación");
                                    console.log("Read failed");
                                }
                            });
                        }
                    }),
                    endButton: new Button({
                        text: "No",
                        press: function () {
                            dialog.close();
                            dialog.destroy();
                        }
                    })
                });

                dialog.open();
            }
        },

        /**
         * Verifica si la raza esta en uso 
         * @param {JSON} process_id
         */
        onVerifyIsUsed: async function (process_id) {
            let ret;
            const response = await fetch("/process/isBeingUsed", {
                headers: {
                    "Content-Type": "application/json"
                },
                method: "POST",
                body: JSON.stringify({
                    process_id: process_id
                })
            });

            if (response.status !== 200 && response.status !== 409) {
                console.log("Looks like there was a problem. Status Code: " +
                    response.status);
                return;
            }
            if (response.status === 200) {
                const res = await response.json();
                ret = res.data.used;
            }
            return ret;

        },

        /**
         * Habilita el campo predecesor
         * @param  {Event} oEvent Evento que llamó esta función
         */
        onChangePredecessor: function (oEvent) {
            let mdprocess = this.getView().getModel("MDPROCESS");

            if (this.getView().byId("ispredecessor_checkbox").getSelected()) {
                mdprocess.setProperty("/predecessor_id/editable", true);
            } else {
                mdprocess.setProperty("/predecessor_id/value", null);
                mdprocess.setProperty("/predecessor_id/editable", false);
                mdprocess.setProperty("/predecessor_id/state", "None");
            }
        },

        /**
         * verificar si una entrada de campo contiene un número utilizando una expresión regular que 
         * permite el formato decimal
         * @param {char} o numero
         */
        validateFloatInput: function (o) {
            let input = o.getSource();
            let floatLength = 2;
            let intLength = 10;

            let value = input.getValue();
            let regex = new RegExp(`/^([0-9]{1,${intLength}})([.][0-9]{0,${floatLength}})?$/`);

            if (regex.test(value)) {
                input.setValueState("None");
                input.setValueStateText("");
                return true;
            } else {
                let pNumber = 0;
                let aux = value.split("")
                    .filter(char => {
                        if (/^[0-9.]$/.test(char)) {
                            if (char !== ".") {
                                return true;
                            } else {
                                if (pNumber === 0) {
                                    pNumber++;
                                    return true;
                                }
                            }
                        }
                    }).join("").split(".");
                value = aux[0].substring(0, intLength);

                if (aux[1] !== undefined) {
                    value += "." + aux[1].substring(0, floatLength);
                }
                input.setValue(value);
                input.setValueState("None");
                input.setValueStateText("");
                this.EnableButtonSave();
                return false;
            }
        },
        /**
         * verificar si una entrada de campo contiene un número utilizando una expresión regular que 
         * permite el formato Entero
         * @param {char} o numero
         */
        validateIntInput: function (o) {
            let input = o.getSource();
            let length = 10;
            let value = input.getValue();
            let regex = new RegExp(`/^[0-9]{1,${length}}$/`);

            if (regex.test(value)) {
                return true;
            } else {
                let aux = value.split("").filter(char => {
                    if (/^[0-9]$/.test(char)) {
                        if (char !== ".") {
                            return true;
                        }
                    }
                }).join("");

                value = aux.substring(0, length);
                input.setValue(value);
                return false;
            }
        },
        /**
         * verificar si una entrada de campo contiene un número utilizando una expresión regular que 
         * permite el formato Entero
         * @param {char} o numero
         */
        validateIntCapacityInput: function (o) {
            let input = o.getSource();
            let length = 10;
            let value = input.getValue();
            let regex = new RegExp(`/^[0-9]{1,${length}}$/`);

            if (regex.test(value)) {
                return true;
            } else {
                let aux = value.split("").filter(char => {
                    if (/^[0-9]$/.test(char)) {
                        if (char !== ".") {
                            return true;
                        }
                    }
                }).join("");
                value = aux.substring(0, length);
                input.setValue(value);
                let mdprocess = this.getView().getModel("MDPROCESS");
                if (parseInt(value) === 0) {
                    input.setValueState("Error");
                    input.setValueStateText("Debe ser mayor a cero (0)");
                    mdprocess.setProperty("/saveEnabled", false);
                } else {
                    input.setValueState("None");
                    input.setValueStateText("");
                    mdprocess.setProperty("/saveEnabled", true);
                }
                this.EnableButtonSave();
                return false;
            }
        },
        /**
         * verificar si una entrada de campo contiene un número utilizando una expresión regular que 
         * permite el formato decimal
         * @param {char} o numero
         */
        validateFloatWeightInput: function (o) {
            let input = o.getSource();
            let floatLength = 2;
            let intLength = 10;

            let value = input.getValue();
            let regex = new RegExp(`/^([0-9]{1,${intLength}})([.][0-9]{0,${floatLength}})?$/`);

            if (regex.test(value)) {
                input.setValueState("None");
                input.setValueStateText("");
                return true;
            } else {
                let pNumber = 0;
                let aux = value.split("")
                    .filter(char => {
                        if (/^[0-9.]$/.test(char)) {
                            if (char !== ".") {
                                return true;
                            } else {
                                if (pNumber === 0) {
                                    pNumber++;
                                    return true;
                                }
                            }
                        }
                    }).join("").split(".");

                value = aux[0].substring(0, intLength);

                if (aux[1] !== undefined) {
                    value += "." + aux[1].substring(0, floatLength);
                }

                input.setValue(value);

                let mdprocess = this.getView().getModel("MDPROCESS"),
                    property = "/" + input.sId.split("product_")[1].split("_input")[0].split("Weight")[0] + "_weight";
                if (parseFloat(value) === 0) {
                    mdprocess.setProperty(property + "/state", "Error")
                    mdprocess.setProperty(property + "/stateText", "Debe ser mayor a cero (0)")
                    mdprocess.setProperty("/saveEnabled", false);
                } else {
                    mdprocess.setProperty(property + "/state", "None")
                    mdprocess.setProperty(property + "/stateText", "")
                    mdprocess.setProperty("/saveEnabled", true);
                }
                this.EnableButtonSave();
                return false;
            }
        },

        /**
         * verificar si una entrada de campo contiene un número utilizando una expresión regular que 
         * permite el formato Entero
         * @param {char} o numero
         */
        validateOrderInput: function (o) {
            let input = o.getSource();
            let length = 10;
            let value = input.getValue();
            let regex = new RegExp(`/^[0-9]{1,${length}}$/`);
            let mdprocess = this.getModel("MDPROCESS");

            if (regex.test(value)) {
                return true;
            } else {
                let aux = value.split("").filter(char => {
                    if (/^[0-9]$/.test(char)) {
                        if (char !== ".") {
                            return true;
                        }
                    }
                }).join("");
                value = aux.substring(0, length);
                input.setValue(value);
                if (value !== undefined && value !== null && value !== "") {
                    value = parseInt(value);
                    let records = mdprocess.getProperty("/records"),
                        used = false;
                    // used = records.find(itm => itm.order === value);
                    records.forEach(itm => {
                        used = used || (itm.process_order === value)
                    });

                    if (used === true) {
                        mdprocess.setProperty("/process_order/state", "Error");
                        mdprocess.setProperty("/process_order/stateText", "El orden ingresado ya fue utilizado");
                        mdprocess.setProperty("/process_order/ok", false);
                        mdprocess.setProperty("/saveEnabled", false);
                    } else {
                        mdprocess.setProperty("/process_order/state", "None");
                        mdprocess.setProperty("/process_order/stateText", "");
                        mdprocess.setProperty("/process_order/ok", true);
                        mdprocess.setProperty("/saveEnabled", true);
                    }
                } else {
                    mdprocess.setProperty("/process_order/state", "None");
                    mdprocess.setProperty("/process_order/stateText", "");
                    mdprocess.setProperty("/process_order/ok", true);
                    mdprocess.setProperty("/saveEnabled", true);
                }

                this.EnableButtonSave();
                return false;
            }
        },
        /**
         *
         * Funcion que valida que todos los campos esten llenados correctamente para habiltar el boton de guardar
         * @param {boolean} [create=false]
         */
        EnableButtonSave: function (create = false) {
            let name_ok = this.getModel('MDPROCESS').getProperty('/name/state') === 'None' || this.getModel('MDPROCESS').getProperty('/name/state') === 'Success',
                order_ok = this.getModel('MDPROCESS').getProperty('/process_order/state') === 'None',
                capacity_ok = this.getModel('MDPROCESS').getProperty('/capacity/state') === 'None',
                state_ok = this.getModel('MDPROCESS').getProperty('/historical_decrease/state') === 'None',
                thDecrease_ok = this.getModel('MDPROCESS').getProperty('/theoretical_decrease/state') === 'None',
                hDecrease_ok = this.getModel('MDPROCESS').getProperty('/historical_decrease/state') === 'None',
                hWeight_ok = this.getModel('MDPROCESS').getProperty('/historical_weight/state') === 'None',
                thWeight_ok = this.getModel('MDPROCESS').getProperty('/theoretical_weight/state') === 'None',
                hDuration_ok = this.getModel('MDPROCESS').getProperty('/historical_duration/state') === 'None',
                thDuration_ok = this.getModel('MDPROCESS').getProperty('/theoretical_duration/state') === 'None',
                ret = name_ok && order_ok && capacity_ok && state_ok && thDecrease_ok && hDecrease_ok && hWeight_ok && thWeight_ok && hDuration_ok && thDuration_ok

            // console.log(name_ok,order_ok,capacity_ok,state_ok,thDecrease_ok,hDecrease_ok,hWeight_ok,thWeight_ok,hDuration_ok,thDuration_ok)
            this.getModel("MDPROCESS").setProperty("/saveEnabled", ret);

        },
        /**
         * Toma el valor de la entrada por la interacción del usuario: cada pulsación de tecla, eliminar, pegar, etc.
         * @param {Event} oEvent Evento que llamó esta función
         */
        changeName: async function (oEvent) {
            let input = oEvent.getSource(),
                nwCode = input.getValue()

            let mdprocess = this.getModel("MDPROCESS");
            let excepcion = mdprocess.getProperty("/name/excepcion");

            if (nwCode.length > 45) {
                mdprocess.setProperty("/name/state", "Error");
                mdprocess.setProperty("/name/stateText", "Excede el limite de caracteres permitido (45)");
                mdprocess.setProperty("/name/ok", false);
            } else {
                await this.checkChange(input.getValue().toString(), excepcion.toString(), "/name", "changeName");
            }
            this.EnableButtonSave();
        },

        /**
         * Valida si el registro de entrada es unico 
         * @param {String} name valor de entrada
         * @param {String} excepcion excepcion del modelo 
         * @param {String} field campo donde se encuentra el focus
         * @param {String} funct funcion a validar
         */
        checkChange: async function (name, excepcion, field, funct) {
            let util = this.getModel("util");
            let mdModel = this.getModel("MDPROCESS");
            if (name == "" || name === null) {
                mdModel.setProperty(field + "/state", "None");
                mdModel.setProperty(field + "/stateText", "");
                mdModel.setProperty(field + "/ok", false);
            } else {
                let registers = mdModel.getProperty("/records");
                let found = await registers.find(element => ((element.name).toLowerCase() === name.toLowerCase() && element.name !== excepcion));

                if (found === undefined) {
                    mdModel.setProperty(field + "/state", "Success");
                    mdModel.setProperty(field + "/stateText", "");
                    mdModel.setProperty(field + "/ok", true);
                } else {
                    mdModel.setProperty(field + "/state", "Error");
                    mdModel.setProperty(field + "/stateText", "nombre ya existente");
                    mdModel.setProperty(field + "/ok", false);
                }
            }
        }


    });
});