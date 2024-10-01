const { CognitoIdentityProviderClient, AdminInitiateAuthCommand, AdminRespondToAuthChallengeCommand } = require('@aws-sdk/client-cognito-identity-provider');

// Função para autenticar um usuário e lidar com o reset de senha obrigatório
const authenticateUser = async (email, password, newPassword = null) => {
  const cognitoIdentityProviderClient= new CognitoIdentityProviderClient({
    region: 'us-east-1',
  });

  try {
    const initiateAuthCommand = new AdminInitiateAuthCommand({
      UserPoolId: process.env.USER_POOL_ID,
      ClientId: process.env.AWS_COGNITO_CLIENT_ID,
      AuthFlow: 'ADMIN_NO_SRP_AUTH',
      AuthParameters: {
        USERNAME: email,
        PASSWORD: password        
      },
    });

    const authResponse = await cognitoIdentityProviderClient.send(initiateAuthCommand);

    // Verifica se há um desafio para mudar a senha
    if (authResponse.ChallengeName === 'NEW_PASSWORD_REQUIRED') {
      if (!newPassword) {
        throw new Error('New password required but not provided');
      }

      const respondToAuthChallengeCommand = new AdminRespondToAuthChallengeCommand({
        UserPoolId: process.env.USER_POOL_ID,
        ClientId: process.env.AWS_COGNITO_CLIENT_ID,
        ChallengeName: 'NEW_PASSWORD_REQUIRED',
        Session: authResponse.Session,
        ChallengeResponses: {
          USERNAME: email,
          NEW_PASSWORD: newPassword,
          
          
        },
      });

      const challengeResponse = await cognitoIdentityProviderClient.send(respondToAuthChallengeCommand);
      console.log('Password changed and user authenticated successfully:', challengeResponse);
      return challengeResponse.AuthenticationResult;
    }

    console.log('User authenticated successfully:', authResponse);
    return authResponse.AuthenticationResult;

  } catch (error) {
    console.error('Error authenticating user:', error);
    throw error;
  }
};

exports.handler = async (event) => {
  const { email, password, newPassword } = JSON.parse(event.body)

  // O newPassword é opcional, para lidar com a mudança de senha
  if (!email || !password) {
    return {
        statusCode: 400,
        body: JSON.stringify({ error: "Email or password are required." }),
    };
  }
  
  try {
      const authResult = await authenticateUser(email, password, newPassword);
      // Return the success response in AWS Lambda format
      return {
          statusCode: 200,
          body: JSON.stringify(authResult),
      };
  } catch(err) {
    return {
        statusCode: 500,
        body: JSON.stringify({ error: err.message }),
    };
  }
};
