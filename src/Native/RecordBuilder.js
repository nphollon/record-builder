Elm.Native.RecordBuilder = {};
Elm.Native.RecordBuilder.make = function (elm) {
    "use strict";
    
    elm.Native = elm.Native || {};
    elm.Native.RecordBuilder = elm.Native.RecordBuilder || {};
    if (elm.Native.RecordBuilder.values) {
        return elm.Native.RecordBuilder.values;
    }

    var translate = function (kvs) {
        var record = { _ : {} };

        while (kvs.ctor !== '[]') {
            addTo(record, kvs._0);
            kvs = kvs._1;
        }

        return record;
    };

    var addTo = function (record, kv) {
        record[kv._0] = kv._1;
    };


    var checkMissingFields = function (expected) {
        return function (actual) {
            return Object.keys(expected).every(function (key) {
                return actual.hasOwnProperty(key);
            });
        };
    };

    var checkExtraFields = function (expected) {
        return function (actual) {
            return Object.keys(expected).length === Object.keys(actual).length;
        };
    };

    var checkTypes = function (expected) {
        return function (actual) {
            return false;
        };
    };
    
    return elm.Native.RecordBuilder.values = {
        translate: translate,
        checkMissingFields: checkMissingFields,
        checkExtraFields: checkExtraFields,
        checkTypes: checkTypes,
    };
};
