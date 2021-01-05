
import AWS from 'aws-sdk'
# import credentials from './credentials'

export default ({ profile, region }) ->

	return new AWS.CloudFormation {
		apiVersion: '2010-05-15'
		credentials: new AWS.SharedIniFileCredentials { profile }
		region
	}
