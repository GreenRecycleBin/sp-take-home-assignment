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
    end
  end
end
