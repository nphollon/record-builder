Elm.Native.RecordBuilder = {};
Elm.Native.RecordBuilder.make = function (elm) {
    "use strict";
    
    elm.Native = elm.Native || {};
    elm.Native.RecordBuilder = elm.Native.RecordBuilder || {};
    if (elm.Native.RecordBuilder.values) {
        return elm.Native.RecordBuilder.values;
    }

    var Show = Elm.Native.Show.make(elm);
    
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


    var checkFields = function (expected) {
        return function (actual) {
            return fieldCountsMatch(expected, actual) && expectedFieldsExist(expected, actual);
        };
    };

    var expectedFieldsExist = function (expected, actual) {
        return Object.keys(expected).every(function (key) {
            if (key === '_') {
                return true;
            }
            
            if (!actual.hasOwnProperty(key)) {
                return false;
            }

            var type = typeof actual[key];
            
            if (type !== "object") {
                return type === typeof expected[key];
            }

            return actual[key].ctor === expected[key].ctor;
        });
    }

    var fieldCountsMatch = function (expected, actual) {
        return Object.keys(expected).length === Object.keys(actual).length;
    };
    
    return elm.Native.RecordBuilder.values = {
        translate: translate,
        checkFields: checkFields,
    };
};
