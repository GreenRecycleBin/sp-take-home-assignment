describe Acme::FriendshipAPI do
  describe 'POST' do
    context 'without params[:friends]' do
      subject { post '/api/friendship' }

      it 'returns 400' do
        subject

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an error' do
        subject

        expect(response.body).to eq({error: 'friends is missing'}.to_json)
      end
    end

    context 'with params[:friends]' do
      subject { post '/api/friendship', params: {friends: friends} }

      context 'when given two email addresses' do
        let(:friends) { %w(a@example.com b@example.com) }

        it 'returns 201' do
          subject

          expect(response).to have_http_status(:created)
        end

        it 'returns the correct body' do
          subject

          expect(response.body).to eq({success: true}.to_json)
        end
      end

      context 'when not given 2 email addresses' do
        let(:friends) { [] }

        it 'returns 400' do
          subject

          expect(response).to have_http_status(:bad_request)
        end

        it 'returns an error' do
          subject

          expect(response.body).to eq({error: 'friends must consist of exactly 2 elements.'}.to_json)
        end
      end

      context 'when given invalid email addresses' do
        let(:friends) { ['a@example.com', 'invalid email'] }

        it 'returns 400' do
          subject

          expect(response).to have_http_status(:bad_request)
        end

        it 'returns an error' do
          subject

          expect(response.body).to eq({error: 'friends must only consist of valid email addresses.'}.to_json)
        end
      end
    end
  end
end
