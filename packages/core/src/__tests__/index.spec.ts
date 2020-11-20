import analytics from '..'
import { AicactusSDK } from '../aicactussdk'

jest.mock('../bridge')

it('exports an instance of Analytics.Client', () =>
	expect(analytics).toBeInstanceOf(AicactusSDK.Client))
