const  { CognitoIdentityProviderClient, AdminCreateUserCommand } = require('@aws-sdk/client-cognito-identity-provider');
const createUser = async (email, cpf, name) => {
  try {

     const cognitoIdentityProviderClient= new CognitoIdentityProviderClient({
      region: 'us-east-1',
    })

    const command = new AdminCreateUserCommand({
      UserPoolId: process.env.USER_POOL_ID,
      Username: email,
      UserAttributes: [
        {
          Name: 'email',
          Value: email,
        },
        {
          Name: 'email_verified',
          Value: 'true',
        },
        {
          Name: 'name',
          Value: name,
        },
        {
          Name: 'custom:cpf',
          Value: cpf,
        },
      ],
    });

    const response = await cognitoIdentityProviderClient.send(command);
    console.log('User created successfully:', response);
  } catch (error) {
    console.error('Error creating user:', error);
    throw new Error(error)
  }
};

exports.handler = async (event) => {
    const email = event['email'];
    const cpf = event['cpf'];
    const name = event['name'];

    // Check for null or undefined values
    if (!email || !cpf || !name) {
        return {
            statusCode: 400,
            body: JSON.stringify({ error: "Email, CPF and name are required." }),
        };
    }

    try {
        const response = await createUser(email, cpf, name);

        // Return the success response in AWS Lambda format
        return {
            statusCode: 200,
            body: JSON.stringify(response),
        };
    } catch(err) {
        return {
            statusCode: 500,
            body: JSON.stringify({ error: err.message }),
        };
    }
};