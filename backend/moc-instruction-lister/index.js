const AWS = require('aws-sdk');

exports.handler = async (event) => {
    const eventPath = event['path'];
    console.log(`eventPath: ${eventPath}`);
    const splittedPath = eventPath.split('/');
    
    const setNum = splittedPath[2];
    console.log(`setNum: ${setNum}`);
    
    const prefix = `${setNum}`;
    console.log(prefix);
        
    const s3 = new AWS.S3();
    var params = {
        Bucket : 'brickapp-mocs',
        Prefix : prefix
    }
    const response = await s3.listObjectsV2(params).promise();
    
    console.log('data' + response);
    return {
        isBase64Encoded: false,
        headers: {
            "Access-Control-Allow-Origin" : "*"
        },
        statusCode: 200,
        body: JSON.stringify(response)
    }
};
