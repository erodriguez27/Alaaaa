sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "liftBreedingPlanningM/model/formatter"
], function (Controller,formatter) {
    "use strict";
    var serviceErrorDlg, connectionErrorDlg, weightDetailsDlg, mermaDetailsDlg, durationDetailsDlg, farmsDialog, centersDialog, shedsDialog;

    return Controller.extend("liftBreedingPlanningM.controller.BaseController", {
        formatter: formatter,

        setFragments : function () {
            // farmDetailsDlg = sap.ui.xmlfragment("liftBreedingPlanningM.view.Popover", this);
            // this.getView().addDependent(mermaDetailsDlg);
            farmsDialog = sap.ui.xmlfragment("liftBreedingPlanningM.view.reports.farmDialog", this);
            this.getView().addDependent(farmsDialog);
            centersDialog = sap.ui.xmlfragment("liftBreedingPlanningM.view.reports.centerDialog", this);
            this.getView().addDependent(centersDialog);
            shedsDialog = sap.ui.xmlfragment("liftBreedingPlanningM.view.reports.shedDialog", this);
            this.getView().addDependent(shedsDialog);
        },

        getI18n: function() {
            return this.getOwnerComponent().getModel("i18n").getResourceBundle();
        },

        onServiceError: function() {
            serviceErrorDlg.open();
        },

        onConnectionError: function() {
            connectionErrorDlg.open();
        },

        onCloseServiceErrorDialog: function() {
            serviceErrorDlg.close();
        },

        onCloseConnectionErrorDialog: function() {
            connectionErrorDlg.close();
        },

        onWeightDetailsDialog: function(ev) {
            var processes = this.getView().getModel("processes");
            processes.setProperty("/selectedRecord", JSON.parse(JSON.stringify(ev.getSource().getBindingContext("processes").getObject())));
            console.log(ev.getSource().getBindingContext("processes").getObject());
            weightDetailsDlg.openBy(ev.getSource());
        },

        onCloseWeightDetailsDialog: function() {
            weightDetailsDlg.close();
        },

        onMermaDetailsDialog: function(ev) {
            var processes = this.getView().getModel("processes");
            processes.setProperty("/selectedRecord", JSON.parse(JSON.stringify(ev.getSource().getBindingContext("processes").getObject())));
            console.log(ev.getSource().getBindingContext("processes").getObject());
            mermaDetailsDlg.openBy(ev.getSource());
        },

        onCloseMermaDetailsDialog: function() {
            mermaDetailsDlg.close();
        },

        onDurationDetailsDialog: function(ev) {
            var processes = this.getView().getModel("processes");
            processes.setProperty("/selectedRecord", JSON.parse(JSON.stringify(ev.getSource().getBindingContext("processes").getObject())));
            console.log(ev.getSource().getBindingContext("processes").getObject());
            durationDetailsDlg.openBy(ev.getSource());
        },

        onCloseDurationDetailsDialog: function() {
            durationDetailsDlg.close();
        },

        sendRequest : function (url, method, data, successFunc, srvErrorFunc, connErrorFunc) {
            var util = this.getModel("util");
            //console.log("datos", data);
            var $settings = {
                url: url,
                method: method,
                data: JSON.stringify(data),
                contentType: "application/json",
                error: err => {
                    //console.log("error", err);
                    util.setProperty("/connectionError/status", err.status);
                    util.setProperty("/connectionError/message", err.statusText);
                    this.onConnectionError();
                    if(connErrorFunc) connErrorFunc(err);

                },
                success: res => {
                    //console.log("respuesta", res);
                    if(res.statusCode !== 200) {
                        util.setProperty("/serviceError/status", res.statusCode);
                        util.setProperty("/serviceError/message", res.msg);
                        this.onServiceError();
                        if(srvErrorFunc) srvErrorFunc(res);
                    } else {
                        successFunc(res);
                    }
                }
            };

            $.ajax($settings);
        },

        /**
			 * Convenience method for accessing the router in every controller of the application.
			 * @public
			 * @returns {sap.ui.core.routing.Router} the router for this component
			 */
        getRouter : function () {
            return this.getOwnerComponent().getRouter();
        },

        /**
			 * Convenience method for getting the view model by name in every controller of the application.
			 * @public
			 * @param {string} sName the model name
			 * @returns {sap.ui.model.Model} the model instance
			 */
        getModel : function (sName) {
            return this.getView().getModel(sName);
        },

        /**
			 * Convenience method for setting the view model in every controller of the application.
			 * @public
			 * @param {sap.ui.model.Model} oModel the model instance
			 * @param {string} sName the model name
			 * @returns {sap.ui.mvc.View} the view instance
			 */
        setModel : function (oModel, sName) {
            return this.getView().setModel(oModel, sName);
        },

        /**
			 * Convenience method for getting the resource bundle.
			 * @public
			 * @returns {sap.ui.model.resource.ResourceModel} the resourceModel of the component
			 */
        getResourceBundle : function () {
            return this.getOwnerComponent().getModel("i18n").getResourceBundle();
        },

        /**
			 * Event handler  for navigating back.
			 * It checks if there is a history entry. If yes, history.go(-1) will happen.
			 * If not, it will replace the current entry of the browser history with the master route.
			 * @public
			 */

			 onNavBack : function() {
            this.getRouter().navTo("home", {}, true /*no history*/);
        },

        onToast: function(message, f) {
            sap.m.MessageToast.show(message, {
                width: "22em",
                duration: 5000,
                closeOnBrowserNavigation: false,
                onClose: f
            });
        },
        handleLinkFarm: function(oEvent){

            var mdreports = this.getView().getModel("mdreports");
            console.log(mdreports);
            // mdreports.setProperty("/selectedRecordDialogF", JSON.parse(JSON.stringify(oEvent.getSource().getBindingContext("mdprogrammed").getObject())));
            let selectObject = oEvent.getSource().getBindingContext("mdreports").getObject();
            console.log("selectObject: ", selectObject);
            let obj = new Array({
                farm_name: selectObject.farm_name,
                executionfarm: selectObject.executionfarm
            });
            mdreports.setProperty("/recordFarms",[]);
            mdreports.setProperty("/recordFarms",obj);

            console.log(mdreports);
            // mdreports.setProperty("/recordFarms/farm_name", selectObject.farm_name);
            // mdreports.setProperty("/recordFarms/executionfarm", selectObject.executionfarm);
            console.log("modelo modificado");
            console.log(mdreports.getProperty("/recordFarms"));
            farmsDialog.openBy(oEvent.getSource());
        },
        handleLinkCenter: function(oEvent){
				
            var mdreports = this.getView().getModel("mdreports");
            console.log(mdreports);
            // mdreports.setProperty("/selectedRecordDialogF", JSON.parse(JSON.stringify(oEvent.getSource().getBindingContext("mdprogrammed").getObject())));
            let selectObject = oEvent.getSource().getBindingContext("mdreports").getObject();
            console.log("selectObject: ", selectObject);
            let obj = new Array({
                center_name: selectObject.center_name,
                executioncenter: selectObject.executioncenter
            });
            mdreports.setProperty("/recordrecordCenters",[]);
            mdreports.setProperty("/recordCenters",obj);

            console.log(mdreports);
            console.log("modelo modificado");
            console.log(mdreports.getProperty("/recordCenters"));
            centersDialog.openBy(oEvent.getSource());
        },
        handleLinkShed: function(oEvent){

            var mdreports = this.getView().getModel("mdreports");
            console.log(mdreports);
            let selectObject = oEvent.getSource().getBindingContext("mdreports").getObject();
            console.log("selectObject: ", selectObject);
            let obj = new Array({
                shed_name: selectObject.shed_name,
                executionshed: selectObject.executionshed
            });
            mdreports.setProperty("/recordSheds",[]);
            mdreports.setProperty("/recordSheds",obj);

            console.log(mdreports);
            console.log("modelo modificado");
            console.log(mdreports.getProperty("/recordSheds"));
            shedsDialog.openBy(oEvent.getSource());
        }
    });
}
);
