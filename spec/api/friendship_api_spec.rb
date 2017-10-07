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

  describe 'GET' do
    context 'without params[:email]' do
      subject { get '/api/friendship' }

      it 'returns 400' do
        subject

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an error' do
        subject

        expect(response.body).to eq({error: 'email is missing'}.to_json)
      end
    end

    context 'with params[:email]' do
      subject { get '/api/friendship', params: {email: email} }

      context 'when given an email address' do
        let(:email) { 'a@example.com' }

        context 'when there are no friends' do
          it 'returns 200' do
            subject

            expect(response).to have_http_status(:ok)
          end

          it 'returns the correct body' do
            subject

            expect(response.body).to eq({success: true, friends: [], count: 0}.to_json)
          end

          context 'one is not a friend of oneself' do
            before { add_friendship(email, email) }

            it 'returns 200' do
              subject

              expect(response).to have_http_status(:ok)
            end

            it 'returns the correct body' do
              subject

              expect(response.body).to eq({success: true, friends: [], count: 0}.to_json)
            end
          end
        end

        context 'when there is one friend' do
          let(:friend_email) { 'b@example.com' }

          before { add_friendship(email, friend_email) }

          it 'returns 200' do
            subject

            expect(response).to have_http_status(:ok)
          end

          it 'returns the correct body' do
            subject

            expect(response.body).to eq({success: true, friends: [friend_email], count: 1}.to_json)
          end

          context 'friendship is mutual' do
            subject { get '/api/friendship', params: {email: friend_email} }

            it 'returns 200' do
              subject

              expect(response).to have_http_status(:ok)
            end

            it 'returns the correct body' do
              subject

              expect(response.body).to eq({success: true, friends: [email], count: 1}.to_json)
            end
          end
        end

        context 'when there are many friends' do
          let(:friend_emails) { %w(b@example.com c@example.com) }

          before do
            friend_emails.each { |friend_email| add_friendship(email, friend_email) }
          end

          it 'returns 200' do
            subject

            expect(response).to have_http_status(:ok)
          end

          it 'returns the correct body' do
            subject

            expect(response.body).to eq({success: true, friends: friend_emails, count: friend_emails.size}.to_json)
          end

          context 'friendship is mutual' do
            subject { get '/api/friendship', params: {email: friend_emails.sample} }

            it 'returns 200' do
              subject

              expect(response).to have_http_status(:ok)
            end

            it 'returns the correct body' do
              subject

              expect(response.body).to eq({success: true, friends: [email], count: 1}.to_json)
            end
          end
        end
      end

      context 'when not given an email address' do
        let(:email) { [] }

        it 'returns 400' do
          subject

          expect(response).to have_http_status(:bad_request)
        end

        it 'returns an error' do
          subject

          expect(response.body).to eq({error: 'email is invalid'}.to_json)
        end
      end

      context 'when given an invalid email address' do
        let(:email) { 'invalid email' }

        it 'returns 400' do
          subject

          expect(response).to have_http_status(:bad_request)
        end

        it 'returns an error' do
          subject

          expect(response.body).to eq({error: 'email must be a valid email address.'}.to_json)
        end
      end
    end

    def add_friendship(a, b)
      unless post('/api/friendship', params: {friends: [a, b]}) == 201
        raise "Failed to add friendship between #{a} and #{b}."
      end
    end
  end
end
