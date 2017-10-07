describe Acme::UpdateAPI do
  describe 'POST' do
    context 'without params[:requestor]' do
      subject { post '/api/update' }

      it 'returns 400' do
        subject

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an error' do
        subject

        expect(response.body).to eq({error: 'requestor is missing'}.to_json)
      end
    end

    context 'without params[:target]' do
      subject { post '/api/update', params: {requestor: 'a@example.com'} }

      it 'returns 400' do
        subject

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an error' do
        subject

        expect(response.body).to eq({error: 'target is missing'}.to_json)
      end
    end

    context 'with params[:requestor]' do
      subject { post '/api/update', params: {requestor: requestor} }

      context 'when not given an email address' do
        let(:requestor) { [] }

        it 'returns 400' do
          subject

          expect(response).to have_http_status(:bad_request)
        end

        it 'returns an error' do
          subject

          expect(response.body).to eq({error: 'requestor is invalid'}.to_json)
        end
      end

      context 'when given an invalid email address' do
        let(:requestor) { 'invalid email' }

        it 'returns 400' do
          subject

          expect(response).to have_http_status(:bad_request)
        end

        it 'returns an error' do
          subject

          expect(response.body).to eq({error: 'requestor must be a valid email address.'}.to_json)
        end
      end

      context 'when given an email address' do
        context 'with params[:target]' do
          subject { post '/api/update', params: {requestor: requestor, target: target} }

          let(:requestor) { 'a@example.com' }

          context 'when not given an email address' do
            let(:target) { [] }

            it 'returns 400' do
              subject

              expect(response).to have_http_status(:bad_request)
            end

            it 'returns an error' do
              subject

              expect(response.body).to eq({error: 'target is invalid'}.to_json)
            end
          end

          context 'when given an invalid email address' do
            let(:target) { 'invalid email' }

            it 'returns 400' do
              subject

              expect(response).to have_http_status(:bad_request)
            end

            it 'returns an error' do
              subject

              expect(response.body).to eq({error: 'target must be a valid email address.'}.to_json)
            end
          end

          context 'when given an email address' do
            let(:target) { 'b@example.com' }

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
  end

  describe 'block' do
    describe 'POST' do
      context 'without params[:requestor]' do
        subject { post '/api/update/block' }

        it 'returns 400' do
          subject

          expect(response).to have_http_status(:bad_request)
        end

        it 'returns an error' do
          subject

          expect(response.body).to eq({error: 'requestor is missing'}.to_json)
        end
      end

      context 'without params[:target]' do
        subject { post '/api/update/block', params: {requestor: 'a@example.com'} }

        it 'returns 400' do
          subject

          expect(response).to have_http_status(:bad_request)
        end

        it 'returns an error' do
          subject

          expect(response.body).to eq({error: 'target is missing'}.to_json)
        end
      end

      context 'with params[:requestor]' do
        subject { post '/api/update/block', params: {requestor: requestor} }

        context 'when not given an email address' do
          let(:requestor) { [] }

          it 'returns 400' do
            subject

            expect(response).to have_http_status(:bad_request)
          end

          it 'returns an error' do
            subject

            expect(response.body).to eq({error: 'requestor is invalid'}.to_json)
          end
        end

        context 'when given an invalid email address' do
          let(:requestor) { 'invalid email' }

          it 'returns 400' do
            subject

            expect(response).to have_http_status(:bad_request)
          end

          it 'returns an error' do
            subject

            expect(response.body).to eq({error: 'requestor must be a valid email address.'}.to_json)
          end
        end

        context 'when given an email address' do
          context 'with params[:target]' do
            subject { post '/api/update/block', params: {requestor: requestor, target: target} }

            let(:requestor) { 'a@example.com' }

            context 'when not given an email address' do
              let(:target) { [] }

              it 'returns 400' do
                subject

                expect(response).to have_http_status(:bad_request)
              end

              it 'returns an error' do
                subject

                expect(response.body).to eq({error: 'target is invalid'}.to_json)
              end
            end

            context 'when given an invalid email address' do
              let(:target) { 'invalid email' }

              it 'returns 400' do
                subject

                expect(response).to have_http_status(:bad_request)
              end

              it 'returns an error' do
                subject

                expect(response.body).to eq({error: 'target must be a valid email address.'}.to_json)
              end
            end

            context 'when given an email address' do
              let(:target) { 'b@example.com' }

              it 'returns 201' do
                subject

                expect(response).to have_http_status(:created)
              end

              it 'returns the correct body' do
                subject

                expect(response.body).to eq({success: true}.to_json)
              end

              it 'disallows adding new friendship' do
                subject

                add_friendship(requestor, target)

                get '/api/friendship', params: {email: requestor}

                expect(response).to have_http_status(:ok)
                expect(response.body).to eq({success: true, friends: [], count: 0}.to_json)

                add_friendship(target, requestor)

                get '/api/friendship', params: {email: target}

                expect(response).to have_http_status(:ok)
                expect(response.body).to eq({success: true, friends: [], count: 0}.to_json)
              end

              context 'when there is an existing friendship' do
                before { add_friendship(requestor, target) }

                it 'returns 201' do
                  subject

                  expect(response).to have_http_status(:created)
                end

                it 'returns the correct body' do
                  subject

                  expect(response.body).to eq({success: true}.to_json)
                end

                it 'does not affect it' do
                  subject

                  get '/api/friendship', params: {email: requestor}

                  expect(response).to have_http_status(:ok)
                  expect(response.body).to eq({success: true, friends: [target], count: 1}.to_json)

                  get '/api/friendship', params: {email: target}

                  expect(response).to have_http_status(:ok)
                  expect(response.body).to eq({success: true, friends: [requestor], count: 1}.to_json)
                end
              end

              context 'one cannot block oneself' do
                let(:target) { requestor }

                it 'returns 201' do
                  subject

                  expect(response).to have_http_status(:created)
                end

                it 'returns the correct body' do
                  subject

                  expect(response.body).to eq({success: true}.to_json)
                end

                it 'does not create any Block' do
                  expect { subject }.not_to change { Block.where(target: target).count }
                end
              end
            end
          end
        end
      end
    end
  end
end
