import analytics from '..'
import { Analytics } from '../aicactussdk'

jest.mock('../bridge')

it('exports an instance of Analytics.Client', () =>
	expect(analytics).toBeInstanceOf(Analytics.Client))
