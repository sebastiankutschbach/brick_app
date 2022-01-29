const AWS = require('aws-sdk');

exports.handler = async (event) => {
    const eventPath = event['path'];
    console.log(`eventPath: ${eventPath}`);
    const splittedPath = eventPath.split('/');
    
    const setNum = splittedPath[2];
    console.log(`setNum: ${setNum}`);
    const mocNum = splittedPath[4];
    console.log(`mocNum: ${mocNum}`);
    
    const key = `${setNum}/${mocNum}.pdf`;
    console.log(key);
        
    const s3 = new AWS.S3();
    var params = {
        Bucket : 'brickapp-mocs',
        Key : key
    }
    const response = await s3.getSignedUrlPromise('getObject', params);
    
    console.log('data' + response);
    return {
        isBase64Encoded: false,
        statusCode: 200,
        headers: {},
        body: JSON.stringify(response)
    }
};
